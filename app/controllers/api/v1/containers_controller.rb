class Api::V1::ContainersController < ApplicationController
    skip_before_action :doorkeeper_authorize!

    def index 
        containers = Container.all
        if params[:activity_type]
            containers = containers.includes(:activity).where(activity: { activity_type: params[:activity_type].to_sym })
            containers = containers.filter do |container|
                container.activity.length > 0
            end
        end
        containers = containers.order("#{params[:sort_by]} #{params[:sort_order]}")
        render json: containers, root: "containers"
    end

    def update 
        container = Container.find(params[:container_id])
        
        container.update()
    end

    def show
        container = Container.find(params[:id])
        render json: container
    end

    def create 
        puts 
        @container = Container.create!(container_params)
        # container_attachments = Container.find(1).ContainerAttachment.create!(photo: params[:photos]["0"])
        render json: "uploaded"
    end

    def show_activity
        @activities = Container.find(params[:id]).activity
        render json: @activities
    end

    def show_comment
        @comments = Container.find(params[:id]).comments
        render json: @comments
    end

    private

    def photo
        params[:photo]&.permit(
            :left,
            :right,
            :front,
            :interior,
            :underside,
            :roof,
            :csc_plate_number
        ) || {}
    end

    def container
        params[:container]&.permit(
            :container_name,
            :container_owner_name,
            :container_height,
            :container_length,
            :container_type,
            :container_manufacture_year
        ) || {}
    end

    private

    def container_attachments_params
        params.permit(:container_id, :photos)
    end
    
    def container_params
        params.permit(:yard_name, :customer)
    end
end
