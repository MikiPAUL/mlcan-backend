require 'rails_helper'

RSpec.describe "API::V1:Customer", type: :request do

    describe 'get customers in the given page' do
        let!(:customer) { create_list(:customer, 25) }
        let!(:user) { create(:user) }
        let!(:token) { authorization user }

        it 'returns 25 customers details' do
            get '/api/customers', headers: { Authorization: token }

            meta = JSON.parse(response.body)["meta"]
            
            expect(meta["total_count"]).to eq(25)
            expect(meta["total_pages"]).to eq(3)
            expect(response.status).to eq(200)
        end

        it 'returns 5 customers in page 3' do
            get '/api/customers?page=3', headers: { Authorization: token }

            expect(JSON.parse(response.body)["customers"].length).to eq(5)
        end

        it 'returns 0 customers in page 40 - page doesnot exist' do
            get '/api/customers.json?page=40', headers: { Authorization: token }
                
            expect(JSON.parse(response.body)["customers"].length).to eq(0)
        end
    end

    describe 'create customer -  post /api/customers' do
        
        let!(:user) { create(:user) }
        let!(:token) { authorization user }

        let!(:customer_params) {
            {
                customer: {
                    name: "Frami",
                    email: "Logan_Schaden@hotmail.com",
                    password: "L25gBleuBRiyHIN",
                    owner_name: "Anthony Lowe",
                    billing_name: "Shannon",
                    hourly_rate: "149.26",
                    tax: {
                        gst: "823.02",
                        pst: "252.13"
                    },
                    location: {
                        city: "Bergnaumfort",
                        address: "508 Beahan Stream",
                        province: "Parker Viaduct",
                        postal_code: "AT"
                    }
                }
            }
        }

        it 'returns 200 - customer created successfully' do
            post '/api/customers', headers: { Authorization: token }, params: customer_params
            
            expect(response.status).to be(201)
        end
    end

end