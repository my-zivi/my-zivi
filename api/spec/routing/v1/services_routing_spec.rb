# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ServicesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/services').to route_to('v1/services#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/v1/services/1').to route_to('v1/services#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/v1/services').to route_to('v1/services#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/services/1').to route_to('v1/services#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/services/1').to route_to('v1/services#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/services/1').to route_to('v1/services#destroy', id: '1', format: :json)
    end

    it 'routes to #confirm' do
      expect(put: '/v1/services/1/confirm').to route_to('v1/services#confirm', id: '1', format: :json)
    end
  end
end
