require 'rails_helper'

RSpec.describe "API::V1:Customer", type: :request do

    describe 'get all customers' do
        let!(:customer) { create_list(:customer, 25) }

        it 'returns 25 customers details' do
            get '/api/customers.json'

            meta = JSON.parse(response.body)["meta"]
            
            expect(meta["total_count"]).to eq(25)
            expect(meta["total_pages"]).to eq(3)
            expect(response.status).to eq(200)
        end

        it 'returns 5 customers in page 3' do
            get '/api/customers?page=3'

            expect(JSON.parse(response.body)["customers"].length).to eq(5)
        end

        it 'returns 0 customers in page 40 - page doesnot exist' do
            get '/api/customers.json?page=40' 
                
            expect(JSON.parse(response.body)["customers"].length).to eq(0)
        end
    end

end