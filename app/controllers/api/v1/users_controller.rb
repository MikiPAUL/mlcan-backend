class Api::V1::UsersController < ApplicationController

    def index 
        users = User.where(is_deleted: false)
        users = users.where("role = ?", User.roles[params["role"]]) if params["role"].present?
        users = users.where("lower(name) LIKE ?", "%" + User.sanitize_sql_like(params["search"].downcase) + "%") if params["search"].present?
        users = users.page(params["page"]).order("#{params["sort_by"]} #{params["sort_order"]}")
        
        render json: users, root: (params["role"] or "users"), meta: pagination_meta(users), adapter: :json
    end

    def create
        user = User.create!(validate_create_params)

        if user.save
            render json: user, status: :created
        else
            render json: user.errors.full_messages, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: params[:id], is_deleted: false)

        if !user 
            render json: { error: "Couldn't able to find the user with id #{params[:id]}"}, status: :unprocessable_entity
        else
            render json: user
        end
    end

    def update
        user = User.find(params[:id])

        update_params.except(:id).each do |key, value|
            user[key] = value unless value.nil?
        end
        if user.save
            render json: user, root: "admin", adapter: :json
        else 
            render json: user.errors.full_messages, status: :unprocessable_entity
        end
    end

    def profile
        render json: current_resource_owner
    end

    def destroy
        user = User.find_by(id: params[:id], is_deleted: false)
        
        if user
            user.is_deleted = true
            user.save
            render json: { status: "user with id #{user.id} deleted successfully"}
        else
            render json: { error: "Couldn't find the user with id #{params[:id]}"}, status: :unprocessable_entity
        end
    end

    private

    def validate_create_params 
        params.require(:user).permit( :email, :password, :role, :phone_number, :name, :status).tap do |params|
            params.require([:email, :password, :status, :role])
        end
    end

    def update_params
        params.require(:user).permit(:name, :password, :phone_number, :email)
    end
end
