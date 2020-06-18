# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it 'defines relations', :aggregate_failures do
      expect(model).to belong_to(:organization)
      expect(model).to have_one(:user).dependent(:destroy).required(true)
    end
  end
end
