class Api::V1::RepairListsController < ApplicationController
    # skip_before_action :doorkeeper_authorize!

    def index
        #version
        @repair_lists = RepairList.where("version <= ?", get_current_version)

        subquery = @repair_lists.select("repair_number, MAX(version) AS version").group("repair_number")

        @repair_lists = RepairList.joins(
        <<-SQL
            JOIN (#{subquery.to_sql}) latest_by_updates
            ON repair_lists.version = latest_by_updates.version
            AND repair_lists.repair_number = latest_by_updates.repair_number
        SQL
        )

        #search
        @repair_lists = @repair_lists.find(params[:search]) unless params[:search].nil?

        #filter 
        @repair_lists = @repair_lists.where(repair_id: params[:repair_id]) unless params[:repair_id].nil?
        @repair_lists = @repair_lists.where(repair_id: params[:damaged_area]) unless params[:damaged_area].nil?
        @repair_lists = @repair_lists.where(repair_id: params[:type]) unless params[:type].nil?
        @repair_lists = @repair_lists.where(repair_id: params[:repair_type]) unless params[:repair_type].nil?

        #pagination and sorting
        @repair_lists = @repair_lists.page(params[:page]).order("#{params[:sort_by]} #{params[:sort_order]}")

        @repair_lists = @repair_lists&.includes(:non_maersk_repair, :merc_repair_type)
    
        render json: @repair_lists, meta: pagination_meta(@repair_lists), root: 'repair_lists', adapter: :json
    end


    def create 
        @repair_list = RepairList.create(repair_lists_params)
        
        if repair_lists_params["repair_type"]  == 'non_maersk'
           @non_maersk = NonMaerskRepair.new(flatten_hash(params["non_maersk_details"]))
           @non_maersk.repair_list_id = @repair_list.id
           @non_maersk.save
        else
            @merc = MercRepair.new(flatten_hash(params["merc_details"]))
            @merc.repair_list_id = @repair_list.id
            @merc.save
        end
        render json: { status: "repair_list created successfully", id: @repair_list.id }, status: :created, adapter: :json
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


    end
    
    def export_xlsx
        p = Axlsx::Package.new
        wb = p.workbook

        # Add a worksheet to the workbook
        wb.add_worksheet(name: 'Data Sheet') do |sheet|
          # Assume you have an array of data named 'data'
        #   data = [
        #     ['Name', 'Age', 'Email'],
        #     ['John Doe', 30, 'john@example.com'],
        #     ['Jane Smith', 25, 'jane@example.com'],
        #     # Add more data rows as needed
        #   ]
          data = RepairList.includes(:non_maersk_repair, :merc_repair_type)
          # Add the data rows to the worksheet
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
        # Generate the XLSX file
        # file_path = Rails.root.join('public', 'exported_data.xlsx')
        # p.serialize(file_path)
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

    def repair_lists_params
        params["repair_details"]["version"] = get_current_version
        params.require(:repair_details)
        .permit(:repair_number, :container_repair_area, :container_damaged_area, :repair_type, :version,
            :component , :event , :location , :id_source , :area , :area2, 
        non_maersk_details: [ cost_details: [ :hours, :material_cost ] , customer_related_details:
         [:container_section , :damaged_area , :repair_type , :description, condition: [:comp, :dam, :rep]]])
    end

    def get_current_version
        params[:version] || Version.last&.id || 1
    end

    def execute_statement(sql)
        # results = ActiveRecord::Base.connection.exec_query(sql)
        results = RepairList.find_by_sql([sql])

        if results.present?
            return results
        else
            return nil
        end
    end


end