# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceSpecification, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[
      name
      internal_note
      identification_number
      accommodation_expenses
      work_clothing_expenses
      work_days_expenses
      paid_vacation_expenses
      first_day_expenses
      last_day_expenses
    ]

    it 'validates the correctness of numerical fields', :aggregate_failures do
      expect(model).to validate_numericality_of(:accommodation_expenses).only_integer
      expect(model).to validate_numericality_of(:work_clothing_expenses).only_integer
      expect(model).to validate_length_of(:identification_number).is_at_least(5).is_at_most(7)
    end
  end

  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'has correct relations' do
      expect(model).to belong_to(:organization)
      expect(model).to have_many(:services)
    end
  end

  describe '#work_days_expenses' do
    subject { service_specification.tap(&:validate).errors.added? :work_days_expenses, error_key }

    let(:error_key) { :wrong_keys }
    let(:expenses) { { breakfast: 400, lunch: 900, dinner: 700 } }
    let(:service_specification) { build(:service_specification, work_days_expenses: expenses) }

    context 'when it has a valid format' do
      it('allows all required keys') { is_expected.to eq false }
    end

    context 'when there are too few keys' do
      let(:expenses) { { breakfast: 400 } }

      it { is_expected.to eq true }
    end

    context 'when there are too many keys' do
      let(:expenses) { { breakfast: 400, lunch: 900, dinner: 700, supper: 12 } }

      it { is_expected.to eq true }
    end

    context 'when there are keys which are invalid' do
      let(:expenses) { { breakfast: 400, lunch: 900, invalid: 700 } }

      it { is_expected.to eq true }
    end

    context 'when there are non numeric values' do
      let(:error_key) { :not_an_unsigned_integer }
      let(:expenses) { { breakfast: 400, lunch: 900, dinner: 'really expensive' } }

      it { is_expected.to eq true }
    end

    context 'when there are negative values' do
      let(:error_key) { :not_an_unsigned_integer }
      let(:expenses) { { breakfast: 400, lunch: -900, dinner: -800 } }

      it { is_expected.to eq true }
    end

    context 'when there are float values' do
      let(:error_key) { :not_an_unsigned_integer }
      let(:expenses) { { breakfast: 400, lunch: -900.123, dinner: 800.123 } }

      it { is_expected.to eq true }
    end
  end

  describe '#title' do
    subject { build(:service_specification, identification_number: 7346, name: 'MyRSpecSpecification').title }

    it { is_expected.to eq '7346 MyRSpecSpecification' }
  end
end
