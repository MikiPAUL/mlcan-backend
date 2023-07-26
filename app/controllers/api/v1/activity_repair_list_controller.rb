class Api::V1::ActivityRepairListController < ApplicationController

    def index 
        @repair_lists = ActivityRepairList.where(activity_id: params[:id])

        render json: @repair_lists
    end

    def create 
        ActiveRecord::Base.transaction do 
            activity_repair_list = ActivityRepairList.create!(repair_list_id: params[:repair_id],
                 activity_id: params[:id], comments: params[:comments])
                 
            activity_repair_list.repair_list_attachments.create!(
                photo_type: :damaged_area, photo: params[:damaged_area]
            )
            activity_repair_list.repair_list_attachments.create!(
                photo_type: :damaged_area, photo: params[:repair_area]
            )
            render json: { status: "Repair added successfully", id: activity_repair_list.id}
        end
    end

    def update 
        
        ActiveRecord::Base.transaction do 
            activity_repair_list = ActivityRepairList.find(params[:id])
            activity_repair_list.update!(update_params)

            activity_repair_list.repair_list_attachments.update(
                flatten_hash create_params[:photo]
            )
        end
        render json: repair_list, status: :ok
    end 

    def show
        repair_list = ActivityRepairList.find(params[:id])

        render json: repair_list
    end

    private 

    def create_params
        params.permit(:repair_id, :comments, :damaged_area, :repaired_area, :id)
    end

    def update_params
        params.require(:activity_repair_list).permit(:repair_id, :comments,
        photo: [:damaged_area, :repaired_area])
    end
end
