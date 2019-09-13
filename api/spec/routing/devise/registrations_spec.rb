# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviseOverrides::RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #validate' do
      expect(post: '/v1/users/validate').to route_to('devise_overrides/registrations#validate', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/v1/users').to route_to('devise_overrides/registrations#create', format: :json)
    end
  end
end
