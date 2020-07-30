require 'rails_helper'

RSpec.describe "MailingLists", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/mailing_list/create"
      expect(response).to have_http_status(:success)
    end
  end

end
