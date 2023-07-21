class Api::V1::ContainersController < ApplicationController

    def index 
        containers = Container.all
        if params[:activity_type]
            containers = containers.includes(:activity).where(activity: { activity_type: params[:activity_type].to_sym })
            containers = containers.filter do |container|
                container.activity.length > 0
            end
        end
        containers = containers.order("#{params[:sort_by]} #{params[:sort_order]}")
        render json: containers, root: 'containers', each_serializer: ContainerSerializer, adapter: :json
    end

    def update 
        container = Container.find(params[:id])

        req_param =  flatten_hash container_params
        
        req_param.each do |key, value|
            container[key] = value
        end
        
        if container.save
            render json: container
        else
            render json: container.errors.full_messages, status: :unprocessable_entity
        end
    end

    def show
        container = Container.find(params[:id])
        render json: container
    end

    def create 
        @container = Container.create!(flatten_hash container_params)
        # container_attachments = Container.find(1).ContainerAttachment.create!(photo: params[:photos]["0"])
        if !@container
            render json: @container.errors.full_messages, status: :unprocessable_entity
        else
            render json: {status: "Successfully created container with id #{@container.id}"}
        end
    end

    def show_activity
        @activities = Container.find(params[:id]).activity
        render json: @activities
    end

    def show_comments
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
        params.require(:container).permit(container_details: [:container_number, :container_length, :container_height,
        :container_manufacture_year, :container_type, :location], customer_details: [:yard_name, :customer_name, :container_owner_name, 
        :submitter_initials, :customer_id])
    end
end
