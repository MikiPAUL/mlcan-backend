class Api::V1::ActivitiesController < ApplicationController
    skip_before_action :doorkeeper_authorize!

    def index
        @activities = Activity.find_by(container_id: params[:id])
        render json: @activities
    end

    def create
        @activity = Activity.new(acitivity_params)

        if @activity.save 
            render json: @activity,  status: :created
        else 
            render status: :unprocessable_entity
        end
    end

    def activity_repair_lists
        Activity.find(params[:activity_id]).create! params[:repair_lists_id]
    end

    def status
        @activity = Activity.find(params[:activity_id])
        @activity.status = params[:status]

        if @activity.save
            render json: @activity, status: :success 
        else
            render status: :unprocessable_entity
        end
    end

    def show
        @activity = ActivityRepairList.find_by(activity_id: params[:id])
        render json: @activity
    end

    def update
        @activity = Activity.find(params[:id])
        old_status_ = @activity.status

        params["activity"].each do |key, value|
            @activity[key] = value
        end
        if @activity.save and @activity.status != old_status_
            log = @activity.logs.create!(old_status: old_status_, new_status: @activity.status)
            render json: log, status: :ok
        else
            render json: {error: "unable to update activity details"}, status: :unprocessable_entity
        end
    end

    def show_logs
        @comments = Activity.comments
        render json: @comments
    end
end
