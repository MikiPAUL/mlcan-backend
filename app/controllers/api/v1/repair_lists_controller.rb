class Api::V1::RepairListsController < ApplicationController
    skip_before_action :doorkeeper_authorize!
    before_action :repair_lists_params, only: %i[create]
    #list all the repair list 
    #filter, search, pagination, sort
    #edit 
    #delete
    #export 
    #versions
    def index
        #version
        @repair_lists = RepairList.where("version <= ?", get_current_version)
        @repair_lists =  @repair_lists.includes(RepairList.most_recent_by_updates)
        #search
        @repair_lists = @repair_lists.where("id LIKE ?", params[:search] + "%") unless params[:search].nil?
        #filter 
        @repair_lists = @repair_lists.where(repair_id: params[:repair_id]) unless params[:repair_id].nil?
        @repair_lists = @repair_lists.where(repair_id: params[:damaged_area]) unless params[:damaged_area].nil?
        @repair_lists = @repair_lists.where(repair_id: params[:type]) unless params[:type].nil?
        @repair_lists = @repair_lists.where(repair_id: params[:repair_type]) unless params[:repair_type].nil?


        #pagination and sorting
        @repair_lists = @repair_lists.page(params[:page]).order("#{params[:sort_by]} #{params[:sort_order]}")

        # repair_list_attr = "repair_lists.id, container_repair_area, container_damaged_area, repair_lists.repair_type"
        # non_maersk_repairs = RepairList.select(repair_list_attr + ", hours as non_maersk_repair_hours, material_cost as non_maersk_repair_mat_cost")
        #           .joins(:non_maersk_repair).to_a
        # merc_repairs = RepairList.select(repair_list_attr + ", hours_per_cost as merc_hours_unit, unit_max_cost as merc_cost_unit")
        #           .joins(:merc_repair_type).to_a

        @repair_lists = @repair_lists.includes(:non_maersk_repair, :merc_repair_type)

        render json: @repair_lists
    end


    def create 
        @repair_lists = RepairList.new(repair_number: params[:repair_number], container_damaged_area: params[:damaged_area],
        container_repair_area: params[:repair_area], version: get_current_version, repair_type: params[:repair_type])
        
        if params[:repair_type]  == 'non_maersk'
            non_maersk = NonMaerskRepair.new(hours: params[:hours], material_cost: params[:material_cost],
                container_section: params[:container_section], damaged_area: params[:damaged_area], repair_type: params[:repair_type],
                description: params[:description], comp: params[:comp], dam: params[:dam], rep: params[:rep], component: params[:component],
                event: params[:event], location: params[:location], area: params[:area], area2: params[:area2], id_source: params[:id_source])
            @repair_lists.save
            @repair_lists.non_maersk.save
        else

        end
        render status: :created
    end

    def create_version
        Version.create!
    end

    def update
        
    end

    private

    def repair_lists_params
        params.require(:repair_details)
        .permit(:repair_number, :repair_area, :damaged_area, :repair_type, :non_maersk_hours, :non_maersk_mat_cost,
        :merc_hours_unit, :merc_mat_cost_unit)
    end

    def get_current_version
        params[:version] || Version.last&.id || 1
    end

    def validate_maersk_params
        params.require(:non_maersk).permit(:hours, :material_cost, :container_section, :damaged_area, :repair_type,
        :description, :comp, :dam, :rep, :component, :event, :location, :area, :area2, :id_source)
    end
end
