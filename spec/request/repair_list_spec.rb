require 'rails_helper'

RSpec.describe "API::V1:Repair_lists", type: :request do

    describe 'get repair_lists' do

        let!(:repair_lists)  { [ 
            create(:repair_list, repair_number: 1, version: 1),
            create(:repair_list, repair_number: 1, version: 2),
            create(:repair_list, repair_number: 2, version: 1),
            create(:repair_list, repair_number: 3, version: 4),
            create(:repair_list, repair_number: 4, version: 5),
            create(:repair_list, repair_number: 1, version: 10),
        ]}

        it 'returns recently updated repair_lists below the version v' do
            get '/api/repair_lists?version=2'
            
            res_data = JSON.parse(response.body)

            expect(res_data.length).to eq(2)
            expect(res_data[0]['repair_number']).to eq(repair_lists.pluck(:repair_number)[1])
            expect(res_data[1]['repair_number']).to eq(repair_lists.pluck(:repair_number)[2])
        end
    end

end