require 'rails_helper'

RSpec.describe "Organizations::Payments", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/organizations/payments/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/organizations/payments/show"
      expect(response).to have_http_status(:success)
    end
  end

end
