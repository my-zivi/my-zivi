# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/v1/users/1').to route_to('v1/users#show', id: '1', format: :json)
    end
  end
end
