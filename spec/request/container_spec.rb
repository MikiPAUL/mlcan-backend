require 'rails_helper'

RSpec.describe "API::V1:Container", type: :request do

    describe 'get all containers' do
        let!(:customer) { create(:customer) }
        let!(:containers)  { create_list(:container, 20, customer_id: customer.id) }

        it 'returns 20 containers details' do
            get '/api/containers.json'
            expect(JSON.parse(response.body).length).to eq(20)
        end

        it 'returns containers sorted order based on yardname' do
            get '/api/containers?sort_by=yard_name&sort_order=asc'

            is_sorted = true

            containers_res = JSON.parse(response.body)

            containers_res.each_cons(2) do |prev, current|
                if (current['yard'].casecmp prev['yard']) == -1
                    is_sorted = false 
                    break
                end
            end

            expect(is_sorted).to eq(true)
        end

        it 'returns containers sorted order based on yardname descending order' do
            get '/api/containers?sort_by=yard_name&sort_order=desc'

            is_sorted = true

            containers_res = JSON.parse(response.body)

            containers_res.each_cons(2) do |prev, current|
                if (current['yard'].casecmp prev['yard']) == 1
                    is_sorted = false 
                    break
                end
            end

            expect(is_sorted).to eq(true)
        end
    end

end