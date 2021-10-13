# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it 'validates the model correctly' do
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

    context 'when latitude and longitude are present' do
      subject(:model) { build(:address, :with_coordinates) }

      %i[latitude longitude].each do |field|
        it_behaves_like 'validates presence of required fields', [field]

        it "validates numericality of #{field}" do
          expect(model).to validate_numericality_of(field)
        end
      end
    end
  end

  describe '#zip_with_city' do
    subject { build(:address, zip: 6274, city: 'RSpec-Hausen').zip_with_city }

    it { is_expected.to eq '6274 RSpec-Hausen' }
  end

  describe '#coordinates' do
    subject { model.coordinates }

    let(:model) { build(:address, latitude: 8, longitude: 9) }

    it { is_expected.to eq [8.0, 9.0] }

    context 'when there are no coordinates' do
      let(:model) { build(:address) }

      it { is_expected.to be_nil }
    end
  end
end
