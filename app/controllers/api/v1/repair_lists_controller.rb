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
        # debugger
        # sql_query = "
        #     SELECT repair_lists.*
        #     FROM repair_lists JOIN (
        #        SELECT repair_number, max(version) AS version FROM repair_lists WHERE version <= #{get_current_version} GROUP BY repair_number
        #     ) latest_by_updates
        #     ON repair_lists.version = latest_by_updates.version
        #     AND repair_lists.repair_number = latest_by_updates.repair_number
        #   "
        #   @repair_lists = execute_statement(sql_query)

        subquery = @repair_lists.select("repair_number, MAX(version) AS version").group("repair_number")

        @repair_lists = RepairList.joins(
        <<-SQL
            JOIN (#{subquery.to_sql}) latest_by_updates
            ON repair_lists.version = latest_by_updates.version
            AND repair_lists.repair_number = latest_by_updates.repair_number
        SQL
        )

        # @repair_lists =  @repair_lists.includes(RepairList.most_recent_by_updates).all
        # @repair_lists = RepairList.group(:repair_number, :id).order(:version).limit(1)
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

        @repair_lists = @repair_lists&.includes(:non_maersk_repair, :merc_repair_type)
        render json: @repair_lists
    end


    def create 
        @repair_list = RepairList.create(repair_lists_params)
        
        if repair_lists_params["repair_type"]  == 'non_maersk'
           @non_maersk = @repair_list.create_non_maersk_repair!(flatten_hash(params["non_maersk_details"]))
        else
            @merc = MercRepairType.new(flatten_hash(params["merc_details"]))
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

    # def flatten_hash(hash)
    #     res = {}
    #     hash.each do |key,value| 
    #       if key == "cost_details" or key == "customer_related_details"
    #         value.each do |val|
    #           res[val[0].to_sym] = val[1]
    #         end
    #       else
    #         res[key.to_sym] = value
    #       end
    #     end
    #     return res
    #   end
end
