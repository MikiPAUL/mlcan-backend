class Api::V1::RepairListsController < ApplicationController
    # skip_before_action :doorkeeper_authorize!
    before_action :add_version, only: [:create]

    def index
        #version
        @repair_lists = RepairList.where("version <= ?", get_current_version)

        subquery = @repair_lists.select("repair_number, MAX(version) AS version").group("repair_number")

        @repair_lists = RepairList.joins(
        <<-SQL
            INNER JOIN (#{subquery.to_sql}) latest_by_updates
            ON repair_lists.version = latest_by_updates.version
            AND repair_lists.repair_number = latest_by_updates.repair_number
        SQL
        )

        #search
        @repair_lists = @repair_lists.where("repair_lists.repair_number LIKE ?", "%" + params[:search].downcase + "%") unless params[:search].nil?

        #filter 
        @repair_lists = @repair_lists.where(repair_id: params[:repair_id]) unless params[:repair_id].nil?
        @repair_lists = @repair_lists.where(container_damaged_area: params[:damaged_area]) unless params[:damaged_area].nil?
        @repair_lists = @repair_lists.where(container_repair_area: params[:repair_area]) unless params[:damaged_area].nil?
        @repair_lists = @repair_lists.where(repair_type: params[:type]) unless params[:type].nil?

        #pagination and sorting
        @repair_lists = @repair_lists.page(params[:page]).order("#{params[:sort_by]} #{params[:sort_order]}")

        @repair_lists = @repair_lists&.includes(:non_maersk_repair, :merc_repair_type)
    
        render json: @repair_lists, meta: pagination_meta(@repair_lists), root: 'repair_lists', adapter: :json
    end


    def create 
        @repair_list = RepairList.new(repair_lists_params["repair_details"])
        
        ActiveRecord::Base.transaction do
            @repair_list.save!
            if @repair_list.repair_type == 'non_maersk'
                @non_maersk = NonMaerskRepair.new(flatten_hash(repair_lists_params["non_maersk_details"]))
                @non_maersk.repair_list_id = @repair_list.id
                @non_maersk.save
            else
                @merc = MercRepairType.new(flatten_hash(repair_lists_params["merc_details"]))
                @merc.repair_list_id = @repair_list.id
                @merc.save
            end
        end
        render json: { status: "repair_list created successfully", id: @repair_list.id }, status: :created, adapter: :json
    end 

    def show
        @repair_list = RepairList.find(params[:id])

        render json: @repair_list
    end

    def create_version
        if Version.create!
            render json: { status: "Version #{Version.last.id} successfully "}
        else
            render json: { error: "Unable to create version" }, status: :unprocessable_entity
        end
    end

    def update
        @repair_list = RepairList.find(params[:id])
        
        if !(@repair_list.version.eql? get_current_version)
            return render json: { error: "Couldn't update the previous versions" }, status: :unprocessable_entity, as: :json
        end

        @repair_list.update(flatten_hash repair_lists_params[:repair_details])

        ActiveRecord::Base.transaction do 
            @repair_list.save!
            if @repair_list.merc? and repair_lists_params[:merc_details].present?

                merc_details = @repair_list.merc_repair_type
                merc_details.update!(flatten_hash(repair_lists_params["merc_details"]))

            elsif @repair_list.non_maersk? and repair_lists_params[:non_maersk_details].present?
                
                non_maersk_details = @repair_list.non_maersk_repair
                non_maersk_details.update!(flatten_hash(repair_lists_params["non_maersk_details"]))
            end
        end
        render json: @repair_list
    end
    
    def export_xlsx
        p = Axlsx::Package.new
        wb = p.workbook

        wb.add_worksheet(name: 'Data Sheet') do |sheet|
        
          data = RepairList.includes(:non_maersk_repair, :merc_repair_type)

          sheet.add_row(['Repair ID', 'Repair area', 'Damaged area', 'type', 'Non-Maersk hours', 
            'Non-Maersk mat. cost', 'Merc+ hours/unit', 'Merc+ mat.cost/unit'])
          data.each do |row|
            
            attr = [row.repair_number, row.container_repair_area ,row.container_damaged_area,
                row.repair_type, row.non_maersk_repair&.hours, row.non_maersk_repair&.material_cost, 
                row.merc_repair_type&.hours_per_cost, row.merc_repair_type&.unit_max_cost]

            attr = attr.map do |att|
                (att.blank? ? "-" : att)
            end
            
            sheet.add_row(attr)
          end
        end
        xlsx_data = p.to_stream.string

        send_data xlsx_data, filename: 'repair_lists.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    end

    def upload
        data = []
        file_path = Rails.root.join('public', 'repair_lists.xlsx')
        xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)

        attr = ['Repair ID', 'Repair area', 'Damaged area', 'type', 'Non-Maersk hours', 
            'Non-Maersk mat. cost', 'Merc+ hours/unit', 'Merc+ mat.cost/unit']

        if attr != xlsx.row(1)
            render json: {error: "upload right file with attributes"}, status: :unprocessable_entity
        else
            data = []
            xlsx.each_row_streaming(offset: 1) do |row|
                data << row.map(&:value)
            end

            RepairList.transaction do
                data.each do |row_data|
                    RepairList.create!(repair_number: row_data[0], container_repair_area: row_data[1],
                    container_damaged_area: row_data[2], repair_type: row_data[3])
                end
            end

            render json: {status: "Data uploaded successfully"}
        end
    
    end

    private

    def add_version
        params["repair_list"]["repair_details"]["version"] = get_current_version
    end

    def repair_lists_params
        params.require(:repair_list)
        .permit(repair_details: [:repair_number, :container_repair_area, :container_damaged_area, :repair_type, :version],
            non_maersk_details: [ cost_details: [ :hours, :material_cost ] , customer_related_details:
            [:component , :event , :location , :id_source , :area , :area2, :container_section , :damaged_area , :repair_type , :description, condition: [:comp, :dam, :rep]]],
           merc_details: [ cost_details: [ :max_min_cost, :unit_max_cost, :hours_per_cost, :max_pieces, :units], 
           customer_related_details: [ :repair_mode, :mode_number, :repair_code, :combined, :description, :id_source]])
        # params.require(:repair_details)
        # .permit(:repair_number, :container_repair_area, :container_damaged_area, :repair_type, :version,
        #     :component , :event , :location , :id_source , :area , :area2, 
        # non_maersk_details: [ cost_details: [ :hours, :material_cost ] , customer_related_details:
        #  [:container_section , :damaged_area , :repair_type , :description, condition: [:comp, :dam, :rep]]])
    end

    def get_current_version
        params[:version] || Version.last&.id || 1
    end
    
end