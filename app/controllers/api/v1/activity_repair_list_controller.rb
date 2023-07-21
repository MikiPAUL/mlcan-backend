class Api::V1::ActivityRepairListController < ApplicationController

    def index 
        @repair_lists = ActivityRepairList.where(activity_id: params[:id])

        render json: @repair_lists
    end

    def create 
        ActivityRepairList.transaction do
            create_activity_repair_list_params[:repair_lists].each do |repair_id|
                ActivityRepairList.create! repair_list_id: repair_id, activity_id: params[:id]
            end
        end
        render json: { status: "Repair added successfully"}
    end

    private 

    def create_activity_repair_list_params
        params.require(:activity_repair_lists).permit(repair_lists: [])
    end
end
