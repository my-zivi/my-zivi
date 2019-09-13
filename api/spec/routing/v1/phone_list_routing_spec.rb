# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PaymentsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/v1/phone_list.pdf').to route_to('v1/phone_list#show', format: 'pdf')
    end
  end
end
