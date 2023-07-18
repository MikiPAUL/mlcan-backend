class Api::V1::UsersController < ApplicationController
    skip_before_action :doorkeeper_authorize!

    def index 
        users = User.where("role = ? and is_deleted = false", (params[:role] == "admin" ? 0 : 1))
        users = users.where("name LIKE ?", "%" + User.sanitize_sql_like(params[:search]) + "%") if params[:search]
        users = users.page(params[:page]).order("#{params[:sort_by]} #{params[:sort_order]}")
        render json: users, root: params[:role]+"s", meta: pagination_meta(users), adapter: :json
    end

    def create
        user = User.create!(validate_create_params)

        if user.save
            render json: user, status: :created
        else
            render json: user.errors.full_messages, status: :unprocessable_entity
        end
    end

    def update
        user = User.find(update_params[:id])

        update_params.except(:id).each do |key, value|
            user[key] = value unless value.nil?
        end
        if user.save
            render json: user, root: "admin"
        else 
            render json: user.errors.full_messages, status: :unprocessable_entity
        end
    end

    def destroy
        user = User.find(params[:id])
        
        if user
            user.is_deleted = true
            user.save
            render json: "deleted successfully"
        else
            render json: user.errors.full_messages, status: :unprocessable_entity
        end
    end

    private

    def validate_create_params 
        params.require(:user).permit( :email, :password, :role, :phone_number, :name, :status).tap do |params|
            params.require([:email, :password, :status, :role])
        end
    end

    def update_params
        params.require(:user).permit(:id, :name, :password, :phone_number, :email).tap do |params|
            params.require(%i[id])
        end
    end
end
