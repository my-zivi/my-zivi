# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it 'validates the model correctly', :aggregate_failures do
      expect(model).to validate_numericality_of(:zip)
                         .only_integer
                         .is_less_than(10_000)
                         .is_greater_than_or_equal_to(1_000)
    end

    it_behaves_like 'validates presence of required fields', %i[
      city
      zip
      street
      primary_line
    ]
  end

  describe '#zip_with_city' do
    subject { build(:address, zip: 6274, city: 'RSpec-Hausen').zip_with_city }

    it { is_expected.to eq '6274 RSpec-Hausen' }
  end
end
