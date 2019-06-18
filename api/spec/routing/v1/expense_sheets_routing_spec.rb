# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ExpenseSheetsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/expense_sheets').to route_to('v1/expense_sheets#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/v1/expense_sheets/1').to route_to('v1/expense_sheets#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/v1/expense_sheets').to route_to('v1/expense_sheets#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/expense_sheets/1').to route_to('v1/expense_sheets#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/expense_sheets/1').to route_to('v1/expense_sheets#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/expense_sheets/1').to route_to('v1/expense_sheets#destroy', id: '1', format: :json)
    end
  end
end
