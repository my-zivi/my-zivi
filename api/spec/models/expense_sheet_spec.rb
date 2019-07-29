# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheet, type: :model do
  it { is_expected.to validate_presence_of :beginning }
  it { is_expected.to validate_presence_of :ending }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :work_days }
  it { is_expected.to validate_presence_of :bank_account_number }
  it { is_expected.to validate_presence_of :state }

  it { is_expected.to validate_numericality_of(:work_days).only_integer }
  it { is_expected.to validate_numericality_of(:workfree_days).only_integer }
  it { is_expected.to validate_numericality_of(:sick_days).only_integer }
  it { is_expected.to validate_numericality_of(:paid_vacation_days).only_integer }
  it { is_expected.to validate_numericality_of(:unpaid_vacation_days).only_integer }
  it { is_expected.to validate_numericality_of(:driving_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:extraordinary_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:clothing_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:unpaid_company_holiday_days).only_integer }
  it { is_expected.to validate_numericality_of(:paid_company_holiday_days).only_integer }

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:expense_sheet, beginning: beginning, ending: ending) }
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
