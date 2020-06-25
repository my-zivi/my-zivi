# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations correctly' do
      expect(model).to belong_to(:organization)
      expect(model).to have_many(:expense_sheets).dependent(:restrict_with_exception)
    end
  end
end
