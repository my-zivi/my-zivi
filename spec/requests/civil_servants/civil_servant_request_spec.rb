require 'rails_helper'

RSpec.describe "CivilServants::CivilServants", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/civil_servants/civil_servants/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/civil_servants/civil_servants/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/civil_servants/civil_servants/update"
      expect(response).to have_http_status(:success)
    end
  end

end
