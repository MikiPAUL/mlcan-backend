require 'rails_helper'

RSpec.describe "API::V1::Authentication", type: :request do

    describe 'post /sign_in' do

        let!(:user) { create(:user) }

        before do
            @user_params = {
                user: {
                    email: user.email,
                    password: user.password
                }
            }
        end
    
        it 'return 200 status - valid credentials' do
        
            post '/api/auth/sign_in', params: @user_params
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)["Authorization"].split(' ')[0]).to eq("Bearer")
        end

    end

    describe 'post /password/new.json' do

        let!(:user) { create(:user) }
        let!(:password_token) { reset_token user }
         
        it 'returns 401 - invalid email' do
            expect(password_token.nil?).to eq(false)
        end
    end

    describe 'put /auth/password' do
        
        let!(:user)  { create(:user) }           
        let!(:password_token) { reset_token user }

        before do
            @password_update_params = { 
                password: {
                    reset_password_token: password_token,
                    password: user.password,
                    password_confirmation: user.password
                }
            }
        end

        it 'successfully updated password' do
            puts password_token["reset_password_token"]
            put '/api/auth/password', params: @password_update_params
            expect(response.status).to eq(200)
        end

    end
    
end