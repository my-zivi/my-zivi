# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PaymentsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/v1/payments/pain.xml').to route_to('v1/payments#show', format: 'xml')
    end
  end
end
