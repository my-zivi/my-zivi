# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PaymentsController, type: :routing do
  describe 'routing' do
    it 'routes to #show with xml' do
      expect(get: '/v1/payments/123.xml').to route_to('v1/payments#show', format: 'xml', payment_timestamp: '123')
    end

    it 'routes to #show' do
      expect(get: '/v1/payments/123').to route_to('v1/payments#show', format: :json, payment_timestamp: '123')
    end

    it 'routes to #index' do
      expect(get: '/v1/payments').to route_to('v1/payments#index', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/payments/123').to route_to('v1/payments#destroy', format: :json, payment_timestamp: '123')
    end

    it 'routes to #confirm' do
      expect(put: '/v1/payments/9/confirm').to route_to('v1/payments#confirm', format: :json, payment_timestamp: '9')
    end

    it 'routes to #create' do
      expect(post: '/v1/payments').to route_to('v1/payments#create', format: :json)
    end
  end
end
