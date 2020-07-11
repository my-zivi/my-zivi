# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations::OrganizationMembers', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/organizations/organization_members/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/organizations/organization_members/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/organizations/organization_members/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/organizations/organization_members/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
