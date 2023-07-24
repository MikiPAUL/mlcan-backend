require 'rails_helper'

RSpec.describe "API::V1:User", type: :request do

    describe 'get all users' do
        let!(:user) { create_list(:user, 30) do  |user|
                user.role = 1 if user.id % 2
        end }
        let!(:token) { authorization user[0] }

        it 'returns user lists' do
            get '/api/users', headers: { Authorization: token }
            expect(JSON.parse(response.body)["users"].length).to eq(10)
        end

        it 'returns admin user only' do
            get '/api/users?role=admin', headers: { Authorization: token }

            expect(JSON.parse(response.body)["admins"].length).to eq(10)
        end
    end
end