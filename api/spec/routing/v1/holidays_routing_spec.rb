# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::HolidaysController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/holidays').to route_to('v1/holidays#index', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/v1/holidays').to route_to('v1/holidays#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/holidays/1').to route_to('v1/holidays#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/holidays/1').to route_to('v1/holidays#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/holidays/1').to route_to('v1/holidays#destroy', id: '1', format: :json)
    end
  end
end
