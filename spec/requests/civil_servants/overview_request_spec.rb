# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CivilServants::Overviews', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/civil_servants/overview/index'
      expect(response).to have_http_status(:success)
    end
  end
end
