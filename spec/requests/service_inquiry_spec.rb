require 'rails_helper'

RSpec.describe "ServiceInquiries", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/service_inquiry/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/service_inquiry/create"
      expect(response).to have_http_status(:success)
    end
  end

end
