# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ServiceCalculatorController, type: :routing do
  describe 'routing' do
    it 'routes to #calculate_service_days' do
      expect(get: '/v1/services/calculate_service_days').to route_to('v1/service_calculator#calculate_service_days',
                                                                     format: :json)
    end

    it 'routes to #calculate_ending' do
      expect(get: '/v1/services/calculate_ending').to route_to('v1/service_calculator#calculate_ending',
                                                               format: :json)
    end
  end
end
