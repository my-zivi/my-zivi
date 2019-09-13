# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ServiceSpecificationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/service_specifications').to route_to('v1/service_specifications#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/v1/service_specifications/1').to(
        route_to('v1/service_specifications#show', format: :json, id: '1')
      )
    end

    it 'routes to #create' do
      expect(post: '/v1/service_specifications').to route_to('v1/service_specifications#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/service_specifications/1').to(
        route_to('v1/service_specifications#update', id: '1', format: :json)
      )
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/service_specifications/1').to(
        route_to('v1/service_specifications#update', id: '1', format: :json)
      )
    end
  end
end
