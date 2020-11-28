# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceSpecification, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[
      name
      identification_number
      accommodation_expenses
      work_clothing_expenses
      work_days_expenses
      paid_vacation_expenses
      first_day_expenses
      last_day_expenses
    ]

    it 'validates the correctness of numerical fields' do
      expect(model).to validate_numericality_of(:accommodation_expenses).is_greater_than_or_equal_to(0)
      expect(model).to validate_numericality_of(:work_clothing_expenses).is_greater_than_or_equal_to(0)
      expect(model).to validate_length_of(:identification_number).is_at_least(5).is_at_most(7)
    end
  end

  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'has correct relations' do
      expect(model).to belong_to(:organization)
      expect(model).to belong_to(:contact_person).class_name('OrganizationMember')
      expect(model).to belong_to(:lead_person).class_name('OrganizationMember')
      expect(model).to have_many(:services)
      expect(model).to have_many(:workshops).through(:service_specifications_workshops)
      expect(model).to have_many(:driving_licenses).through(:driving_licenses_service_specifications)
    end
  end

  describe '#initialize' do
    subject(:service_specification) { described_class.new }

    it 'defines default expense hashes' do
      %i[work_days_expenses paid_vacation_expenses first_day_expenses last_day_expenses].each do |attribute|
        expect(service_specification.public_send(attribute)).to eq('breakfast' => nil, 'lunch' => nil, 'dinner' => nil)
      end
    end

    context 'when passing a default' do
      subject(:service_specification) { described_class.new(first_day_expenses: initial_expenses) }

      let(:initial_expenses) { { 'breakfast' => 300, 'lunch' => 500, 'dinner' => 900 } }

      it 'does not override passed default' do
        expect(service_specification.first_day_expenses).to eq initial_expenses
      end
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
      let(:error_key) { :not_a_positive_currency_amount }
      let(:expenses) { { breakfast: 400, lunch: 900, dinner: 'really expensive' } }

      it { is_expected.to eq true }
    end

    context 'when there are negative values' do
      let(:error_key) { :not_a_positive_currency_amount }
      let(:expenses) { { breakfast: 400, lunch: -900, dinner: -800 } }

      it { is_expected.to eq true }
    end

    context 'when there are float values' do
      let(:error_key) { :not_a_positive_currency_amount }
      let(:expenses) { { breakfast: 400, lunch: -900.123, dinner: 800.123 } }

      it { is_expected.to eq true }
    end
  end

  describe '#title' do
    subject { service_specification.title }

    let(:service_specification) { build(:service_specification, identification_number: 7346, name: 'MySpecification') }

    it { is_expected.to eq '7346 MySpecification' }
  end
end
