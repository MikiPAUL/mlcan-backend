require 'axlsx'

class Api::V1::CustomersController < ApplicationController
    skip_before_action :doorkeeper_authorize!
    # include ActionView::Rendering

    def index 
        @customers = Customer.all
        @customers = @customers.where("name LIKE ?", "%" + Customer.sanitize_sql_like(params[:search]) + "%") if params[:search]
        @customers = @customers.page(params[:page]).order("#{params[:sort_by]} #{params[:sort_order]}")
        respond_to do |format|
            format.json { (render json: @customers, meta: pagination_meta(@customers), adapter: :json) }
            format.xlsx {
              response.headers['Content-Disposition'] = 'attachment; filename="all_customers.xlsx"'
            }
         end
        # Axlsx::Package.new do |p|
        #     p.workbook.add_worksheet(name: "Users") do |sheet|
        #       @customers.each do |user|
        #         # sheet.add_row ["name", "email"]
        #         # debugger
        #         # sheet.add_row [user[:name], user[:email]], types: %i[string string]
        #       end
        #     end
        #     send_data Base64.encode64(p.to_stream.read), filename: "users.csv", type: "text/csv", handlers: [:axlsx], formats: [:xlsx]
        # end    
    end

    def create 
      @customer = Customer.new(flatten_hash customer_create_params)
      if !@customer.nil? and @customer.save
        render json: { customer_id: @customer.id }, status: :created, formats: [:json]
      else 
        render status: :unprocessable_entity
      end
    end

    def 

    def list_repair 
      redirect_to controller: :repair_list, action: :index
    end

    private 

    def customer_create_params
      params.require(:customer).permit(:name, :email, :password, :owner_name, 
        :billing_name, :hourly_rate,{ :tax => [:gst, :pst]}, 
        { :location => [:city, :address, :province, :postal_code] },  :repair_list, :status)
    end

    def flatten_hash(hash)
      res = {}
      hash.each do |key,value| 
        if key == "tax" or key == "location"
          value.each do |val|
            res[val[0].to_sym] = val[1]
          end
        else
          res[key.to_sym] = value
        end
      end
      return res
    end
    
end
