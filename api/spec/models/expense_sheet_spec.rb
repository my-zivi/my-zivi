# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheet, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    let(:only_integer_fields) do
      %i[
        work_days
        workfree_days
        sick_days
        paid_vacation_days
        unpaid_vacation_days
        driving_expenses
        extraordinary_expenses
        clothing_expenses
        unpaid_company_holiday_days
        paid_company_holiday_days
      ]
    end

    it_behaves_like 'validates presence of required fields', %i[
      beginning
      ending
      user
      work_days
      bank_account_number
      state
    ]

    it 'validates the correctness of numerical fields correctly', :aggregate_failures do
      only_integer_fields.each do |field|
        expect(model).to validate_numericality_of(field).only_integer
      end
    end
  end

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:expense_sheet, beginning: beginning, ending: ending) }
  end

  describe '#destroy' do
    let!(:expense_sheet) { create :expense_sheet }

    context 'when the expense sheet is not already paid' do
      it 'destroys the expense_sheet' do
        expect { expense_sheet.destroy }.to change(ExpenseSheet, :count).by(-1)
      end
    end

    context 'when the expense sheet is already paid' do
      let!(:expense_sheet) { create :expense_sheet, :paid }

      it 'does not destroy the expense_sheet' do
        expect { expense_sheet.destroy }.not_to change(ExpenseSheet, :count)
      end

      it 'returns an error' do
        expense_sheet.destroy
        expect(expense_sheet.errors[:base]).to include(I18n.t('expense_sheet.errors.already_paid'))
      end
    end
  end

  describe '#state' do
    subject { !expense_sheet.errors.added?(:state, :invalid_state_change) }

    before { expense_sheet.update(state: state) }

    let(:expense_sheet) do
      expense_sheet = build(:expense_sheet, user: user, state: state_was)
      expense_sheet.save validate: false
      expense_sheet
    end
    let(:user) { create :user }

    context 'when state was open' do
      let(:state_was) { :open }

      context 'when new state is ready_for_payment' do
        let(:state) { :ready_for_payment }

        it { is_expected.to eq true }
      end

      context 'when new state is payment_in_progress' do
        let(:state) { :payment_in_progress }

        it { is_expected.to eq false }
      end

      context 'when new state is paid' do
        let(:state) { :paid }

        it { is_expected.to eq false }
      end
    end

    context 'when state was ready_for_payment' do
      let(:state_was) { :ready_for_payment }

      context 'when new state is open' do
        let(:state) { :open }

        it { is_expected.to eq true }
      end

      context 'when new state is payment_in_progress' do
        let(:state) { :payment_in_progress }

        it { is_expected.to eq true }
      end

      context 'when new state is paid' do
        let(:state) { :paid }

        it { is_expected.to eq false }
      end
    end

    context 'when state was payment_in_progress' do
      let(:state_was) { :payment_in_progress }

      context 'when new state is open' do
        let(:state) { :open }

        it { is_expected.to eq false }
      end

      context 'when new state is ready_for_payment' do
        let(:state) { :ready_for_payment }

        it { is_expected.to eq true }
      end

      context 'when new state is paid' do
        let(:state) { :paid }

        it { is_expected.to eq true }
      end
    end

    context 'when state was paid' do
      let(:state_was) { :paid }

      context 'when new state is open' do
        let(:state) { :open }

        it { is_expected.to eq false }
      end

      context 'when new state is ready_for_payment' do
        let(:state) { :ready_for_payment }

        it { is_expected.to eq false }
      end

      context 'when new state is payment_in_progress' do
        let(:state) { :payment_in_progress }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#duration' do
    let(:expense_sheet) { build :expense_sheet, beginning: beginning, ending: ending }
    let(:beginning) { Time.zone.today }
    let(:ending) { beginning + 2.days }

    it 'returns duration' do
      expect(expense_sheet.duration).to eq 3
    end
  end

  describe '#total_paid_vacation_days' do
    subject { expense_sheet.total_paid_vacation_days }

    let(:expense_sheet) do
      create :expense_sheet, paid_vacation_days: 2, paid_company_holiday_days: 1, unpaid_company_holiday_days: 3
    end

    it { is_expected.to eq 3 }
  end

  describe '#at_service_beginning?' do
    let(:expense_sheet) { create :expense_sheet, expense_sheet_data }
    let(:service) { create :service, service_data }

    let(:service_data) do
      {
        beginning: Date.parse('2018-01-01'),
        ending: Date.parse('2018-08-03')
      }
    end

    context 'when expense_sheet is at beginning of service' do
      let(:expense_sheet_data) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-01-31'),
          work_days: 23,
          user: service.user
        }
      end

      it 'returns true' do
        expect(expense_sheet.at_service_beginning?).to eq true
      end
    end

    context 'when expense_sheet is not at beginning of service' do
      let(:expense_sheet_data) do
        {
          beginning: Date.parse('2018-02-01'),
          ending: Date.parse('2018-02-28'),
          work_days: 23,
          user: service.user
        }
      end

      it 'returns false' do
        expect(expense_sheet.at_service_beginning?).to eq false
      end
    end
  end

  describe '#at_service_ending?' do
    let(:expense_sheet) { create :expense_sheet, expense_sheet_data }
    let(:service) { create :service, service_data }

    let(:service_data) do
      {
        beginning: Date.parse('2018-01-01'),
        ending: Date.parse('2018-08-03')
      }
    end

    context 'when expense_sheet is at ending of service' do
      let(:expense_sheet_data) do
        {
          beginning: Date.parse('2018-01-08'),
          ending: Date.parse('2018-08-03'),
          work_days: 3,
          user: service.user
        }
      end

      it 'returns true' do
        expect(expense_sheet.at_service_ending?).to eq true
      end
    end

    context 'when expense_sheet is not at ending of service' do
      let(:expense_sheet_data) do
        {
          beginning: Date.parse('2018-02-01'),
          ending: Date.parse('2018-02-28'),
          work_days: 23,
          user: service.user
        }
      end

      it 'returns false' do
        expect(expense_sheet.at_service_ending?).to eq false
      end
    end
  end
end
