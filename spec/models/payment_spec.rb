# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations and enums correctly' do
      expect(model).to belong_to(:organization)
      expect(model).to have_many(:expense_sheets).dependent(:restrict_with_exception)
      expect(model).to define_enum_for(:state)
    end
  end

  describe 'validations' do
    subject(:model) { described_class.new }

    it 'validates the model correctly' do
      expect(model).to validate_numericality_of(:amount).is_greater_than(0)
      expect(model).to validate_presence_of(:amount)
      expect(model).not_to validate_presence_of(:paid_timestamp)
    end

    context 'when payment is paid' do
      subject { build(:payment, :paid) }

      it { is_expected.to validate_presence_of(:paid_timestamp) }
    end
  end
end
