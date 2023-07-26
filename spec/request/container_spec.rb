require 'rails_helper'

RSpec.describe "API::V1:Container", type: :request do

    describe 'get all containers' do
        let!(:user) { create(:user) }
        let!(:token) { authorization user }
        let!(:customer) { create(:customer) }
        let!(:containers)  { create_list(:container, 20, customer_id: customer.id) }

        it 'returns total count 20 containers details' do
            get '/api/containers', headers: { Authorization: token }, as: :json
            
            expect(JSON.parse(response.body)["meta"]["total_count"]).to eq(20)
        end

        it 'returns containers sorted order based on yardname' do
            get '/api/containers?sort_by=yard_name&sort_order=asc', headers: { Authorization: token }, as: :json

            is_sorted = true
            
            containers_res = JSON.parse(response.body)["containers"]
            containers_res.each_cons(2) do |prev, current|
                if (current['yard'].casecmp prev['yard']) == -1
                    is_sorted = false 
                    break
                end
            end

            expect(is_sorted).to eq(true)
        end

        it 'returns containers sorted order based on yardname descending order' do
            get '/api/containers?sort_by=yard_name&sort_order=desc', headers: { Authorization: token }, as: :json

            is_sorted = true

            containers_res = JSON.parse(response.body)["containers"]

            containers_res.each_cons(2) do |prev, current|
                if (current['yard'].casecmp prev['yard']) == 1
                    is_sorted = false 
                    break
                end
            end

            expect(is_sorted).to eq(true)
        end
    end

    describe 'get containers with specific container status' do
        let!(:customer) { create(:customer) }
        let!(:user) { create(:user) }
        let!(:token) { authorization user }
        let!(:containers) { create_list(:container, 30, customer_id: customer.id) }
        let!(:activities) { build_list(:activity, 30) do |record, i| 
                record.container_id = containers[i].id
                record.status = "quote_pending" if i.even?
                record.save!
            end 
        }


        it 'returns all container type draft -  result should be 30' do
            get "/api/containers?container_type=draft", headers: { Authorization: token }, as: :json
            
            res = JSON.parse(response.body)["meta"]["total_count"]
            
            expect(res).to eq(15)
        end

        it 'returns all container type customer approval pending -  result should be 0' do
            get "/api/containers?container_type=pending_customer_approval", headers: { Authorization: token }, as: :json
            
            res = JSON.parse(response.body)["meta"]["total_count"]
            
            expect(res).to eq(0)
        end

    end

    describe 'post /api/containers' do
        let!(:user) { create(:user) }
        let!(:token) { authorization user }

        
        let!(:containers_params) {{
            container: {
                container_details: {
                    container_number: "e34649e3-1808-43d0-bb9e-e474acbd5fdf",
                    container_length: "593.54",
                    container_height: "427.58",
                    container_manufacture_year: "Fri Feb 17 2023 14:30:18 GMT+0530 (India Standard Time)",
                    container_type: "Senior",
                    location: "66267 Jermain Fall"
                },
                customer_details: {
                    yard_name: "Dickens Group",
                    customer_name: "III",
                    container_owner_name: "Josh Kuphal",
                    submitter_initials: "Dr.",
                    customer_id: 1
                }
            }
        }}
    

        it "return 201 - successfully created a container" do
            post '/api/containers', headers: { Authorization: token }, params: containers_params, as: :json

            expect(response.status).to eq(200)
        end
    end

end