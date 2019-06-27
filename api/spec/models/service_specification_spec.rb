# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceSpecification, type: :model do
  it { is_expected.to validate_presence_of :short_name }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :identification_number }
  it { is_expected.to validate_presence_of :accommodation_expenses }
  it { is_expected.to validate_presence_of :work_clothing_expenses }
  it { is_expected.to validate_presence_of :work_days_expenses }
  it { is_expected.to validate_presence_of :paid_vacation_expenses }
  it { is_expected.to validate_presence_of :first_day_expenses }
  it { is_expected.to validate_presence_of :last_day_expenses }

  it { is_expected.to validate_numericality_of(:accommodation_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:work_clothing_expenses).only_integer }
  it { is_expected.to validate_length_of(:identification_number).is_at_least(5).is_at_most(7) }

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
