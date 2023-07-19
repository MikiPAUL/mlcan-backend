require 'rails_helper'

RSpec.describe "API::V1:Repair_lists", type: :request do

    describe 'get all repair_lists' do

        let!(:repair_lists)  { [
            create(:repair_list, version: 1, repair_number: 1, container_damaged_area: "version 1"),
            create(:repair_list, version: 2, repair_number: 1, container_damaged_area: "version 2"),
            create(:repair_list, version: 1, repair_number: 2),
            create(:repair_list, version: 1, repair_number: 3),
            create(:repair_list, version: 1, repair_number: 4),
            create(:repair_list, version: 1, repair_number: 5),
            create(:repair_list, version: 1, repair_number: 6),
            create(:repair_list, version: 1, repair_number: 7),
            create(:repair_list, version: 1, repair_number: 8),
            create(:repair_list, version: 1, repair_number: 9),
            create(:repair_list, version: 1, repair_number: 10)
        ] }

        it 'returns 30 repair lists details' do
            get '/api/repair_lists?version=4'

            expect(JSON.parse(response.body).length).to eq(30)
        end
    end

end