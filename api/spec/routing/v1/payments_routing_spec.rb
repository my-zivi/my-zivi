# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PaymentsController, type: :routing do
  describe 'routing' do
    it 'routes to #export' do
      expect(get: '/v1/payments/pain').to route_to('v1/payments#export', format: :json)
    end
  end
end
