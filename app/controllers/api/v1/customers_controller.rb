class Api::V1::CustomersController < ApplicationController

    def index 
        @customers = Customer.all
        @customers = @customers&.where("name LIKE ?", "%" + Customer.sanitize_sql_like(params[:search]) + "%") if params[:search]
        @customers = @customers&.page(params[:page]).order("#{params[:sort_by]} #{params[:sort_order]}")

        render json: @customers, root: 'customers', meta: pagination_meta(@customers), adapter: :json
    end

    def create 
      @customer = Customer.new(flatten_hash customer_params)
      if @customer&.save
        render json: { customer_id: @customer.id, status: "Customer created successfully" }, status: :created, formats: [:json]
      else 
        render status: :unprocessable_entity
      end
    end

    def show
      @customer = Customer.find(params[:id])

      if @customer
        render json: @customer, root: "customer", adapter: :json
      else
        render json: "Couldn't able to find user with id #{params[:id]}", status: :unprocessable_entity
      end
    end

    def update 
      @customer = Customer.find(params[:id])

      if @customer.nil?
        render json: "Couldn't able to find user with id #{params[:id]}", status: :unprocessable_entity
      else
        if @customer.update(flatten_hash customer_params)
          render json: @customer, status: :ok
        else
          render json: @customer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end

    private 

    def customer_params

      params.require(:customer).permit(:name, :email, :password, :owner_name, 
        :billing_name, :hourly_rate,{ :tax => [:gst, :pst]}, 
        { :location => [:city, :address, :province, :postal_code] },  :repair_list, :status)
    end
end
