# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RegionalCentersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/regional_centers').to route_to('v1/regional_centers#index', format: :json)
    end
  end
end
