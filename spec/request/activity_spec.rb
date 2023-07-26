require 'rails_helper'

RSpec.describe "Api::V1::Activity", type: :request do
  describe "GET /index" do

    let!(:user) { create(:user) }
    let!(:customer) { create(:customer) }
    let!(:container) { create(:container, customer_id: customer.id) }
    let!(:activity) { create_list(:activity, 30, container_id: container.id) }
    let!(:token) { authorization user }

    it 'returns number of repair lists created' do

        get "/api/container/#{container.id}/activities", headers: { Authorization: token }, as: :json
        
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).length).to be(30)
    end

    it 'returns unauthorized error - token not provided' do
        get "/api/container/#{container.id}/activities"

        expect(response.status).to eq(401)
    end
  end
end
