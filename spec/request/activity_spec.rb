require 'rails_helper'

RSpec.describe "API::V1:Activity", type: :request do

    describe 'get all activities' do

        let!(:repair_lists)  { create_list(:repair_list, 30) }

        it 'returns 30 repair lists details' do
            get '/api/repair_lists?version=4'
            debugger
            expect(JSON.parse(response.body).length).to eq(30)
        end
    end

end