class Api::V1::ContainersController < ApplicationController

    def index 
        containers = Container.select("containers.id as id, container_number, yard_name, customer_name, container_owner_name, 
            activities.activity_type, activities.created_at, activities.status").left_outer_joins(:activity)
        
        if params["container_type"].present? and !(params["container_type"].eql? "all")
            status = container_status[params["container_type"].to_sym].map do |ele| Activity.statuses[ele] end
            containers = containers.where("activities.status in (?)", status)
        end

        containers = containers.where("activities.created_at = ?", params["date"]) if params["date"].present?
        # containers = containers.par if params["activity"].present?
        
        containers = containers.where("activity_type = ?", Activity.activity_types[params["activity"].to_sym]) if params["activity"].present?
        
        containers = containers.where("status = ?", Activity.statuses[params["status"].to_sym]) if params["status"].present?
        containers = containers.where("yard_name = ?", params["yard"]) if params["yard"].present?
        containers = containers.where("customer_name = ?", parmas["customer"]) if params["customer"].present?
        containers = containers.where("container_number = ?", params[:container_number]) if params["container"].present?

        containers = containers.page((params["page"] or 1))
        containers = containers.order(Arel.sql("#{params["sort_by"]} #{params["sort_order"]}")) if params["sort_by"].present?
        render json: containers, root: 'containers', meta: pagination_meta(containers), each_serializer: ContainerSerializer, adapter: :json
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
        @container = Container.new(flatten_hash container_params)
        # container_attachments = Container.find(1).ContainerAttachment.create!(photo: params[:photos]["0"])
        if !@container.save!
            render json: @container.errors.full_messages, status: :unprocessable_entity
        else
            render json: {status: "Successfully created container with id #{@container.id}"}, status: :created
        end
    end


    def customer_approve
        @containers_id = parmas[:containers]

        @containers_id.each do |id|
            Container.find(id).activity.update!(status: "quote_approved")
        end
        render json: { status: "Selected quotes moved successfully" }
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

    def container_status
        {
            draft: [ :quote_draft, :repair_draft, :inspection_draft ],
            admin_review_pending: [ :quote_pending, :repair_done, :inspection_done ],
            pending_customer_approval: [ :quote_issued ],
            quote_approved_by_customer: [ :quote_approved ]
        }
    end
end
