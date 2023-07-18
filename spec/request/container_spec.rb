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
            get '/api/containers?sortby=yardname&sortorder=asc'

            is_sorted = true; prev = nil

            containers_res = JSON.parse(response.body)
            
            containers_res.each do |container|
                if !prev.nil? and ((container["yard"].casecmp prev) == -1)
                    is_sorted = false 
                    break
                end
                prev = container["yard"]
            end

            expect(is_sorted).to eq(true)
        end
    end

end