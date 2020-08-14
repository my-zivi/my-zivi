require 'rails_helper'

RSpec.describe 'Organizations::CivilServants', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/organizations/civil_servants/index'
      expect(response).to have_http_status(:success)
    end
  end
end
