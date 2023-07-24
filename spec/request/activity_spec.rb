require 'rails_helper'

RSpec.describe "Api::V1::Activity", type: :request do
  describe "GET /index" do

    let!(:activity) { create_list(:activity, 30) }
    let!(:user) { create(:user) }
    let!(:token) { authorization user }

    it 'returns number of repair lists created' do

        get '/api/activities', headers: { Authorization: token }, as: :json
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).length).to be(30)
    end

    it 'returns unauthorized error - token not provided' do
        get '/api/activities'

        expect(response.status).to eq(401)
    end
  end
end
