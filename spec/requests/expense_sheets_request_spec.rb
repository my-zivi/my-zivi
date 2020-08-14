require 'rails_helper'

RSpec.describe "ExpenseSheets", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/expense_sheets/show"
      expect(response).to have_http_status(:success)
    end
  end

end
