require 'rails_helper'

#things to test 
#create user 
#show user
#update
#destroy
#profile

RSpec.describe "API::V1:User", type: :request do

    describe 'get all users' do
        let!(:user) { create_list(:user, 30) do  |record, i|
                record.role = 1 if i.even?
                record.save!
        end }
        let!(:token) { authorization user[0] }

        it 'returns user lists' do
            get '/api/users', headers: { Authorization: token }
            
            expect(JSON.parse(response.body)["meta"]["total_count"]).to eq(30)
        end

        it 'returns admin user only' do
            get '/api/users?role=admin', headers: { Authorization: token }
            
            expect(JSON.parse(response.body)["meta"]["total_count"]).to eq(15)
        end

    end

    describe 'create new user' do
        
        let!(:user) { create(:user) }
        let!(:token) { authorization user }
        let!(:user_params){
            {
                "user": {
                    "email": "Jude_Braun8@yahoo.com",
                    "password": "eenBV6DciJNMlKb",
                    "role": "employee",
                    "phone_number": "206-218-3299",
                    "name": "Trisha_Senger",
                    "status": "active"
                }
            }
        }

        it 'returns 201 - successfully created new user' do 
            
            post '/api/users', headers: { Authorization: token }, params: user_params

            expect(response.status).to eq(201)
        end
        
    end

    describe "put /api/users" do

        let!(:user) { create(:user) }
        let!(:token) { authorization user }
        let!(:user_params){
            {
                "user": {
                    "email": "Jude_Braun8@yahoo.com",
                    "password": "eenBV6DciJNMlKb",
                    "role": "employee",
                    "phone_number": "206-218-3299",
                    "name": "Trisha_Senger",
                    "status": "active"
                }
            }
        }

        before do 
            post '/api/users', headers: { Authorization: token }, params: user_params
        end

        let!(:update_params){
            {
                "user": {
                    "email": "Jude_Braun9@yahoo.com",
                    "phone_number": "206-218-3299",
                    "name": "updated_name"
                }
            }
        }

        it 'update user details' do

            put "/api/users/#{user.id}", headers: { Authorization: token }, params: update_params

            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)["admin"]['name']).to eq("updated_name")
        end

    end
end