# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheet, type: :model do
  describe 'validations' do
    before { create :service, user: user }

    let(:user) { create :user }
    let(:expense_sheet) { build :expense_sheet, user: user }

    let(:present_fields) do
      %i[beginning ending user work_days bank_account_number state]
    end

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

    it 'validates that required fields are present', :aggregate_failures do
      present_fields.each do |field|
        expect(expense_sheet).to validate_presence_of field
      end
    end

    it 'validates the correctness of numerical fields correctly', :aggregate_failures do
      only_integer_fields.each do |field|
        expect(expense_sheet).to validate_numericality_of(field).only_integer
      end
    end

    describe '#included_in_service_date_range' do
      let(:beginning) { Date.parse('2019-09-02') }
      let(:ending) { Date.parse('2019-09-27') }

      let(:user) { create :user }

      before { create :service, user: user, beginning: beginning, ending: ending }

      context 'when expense_sheet is in service period' do
        subject(:expense_sheet) do
          build(:expense_sheet, user: user, beginning: beginning, ending: ending).tap(&:validate)
        end

        it 'is valid' do
          expect(expense_sheet.errors[:base]).to be_empty
        end
      end

      context 'when expense_sheet is outside service period' do
        subject(:expense_sheet) do
          build(:expense_sheet, user: user, beginning: invalid_beginning, ending: invalid_ending).tap(&:validate)
        end

        let(:invalid_beginning) { Date.parse('2019-09-28') }
        let(:invalid_ending) { Date.parse('2019-09-28') }

        it 'added error' do
          expect(expense_sheet.errors[:base]).to include I18n.t('expense_sheet.errors.outside_service_date_range')
        end
      end
    end
  end

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:expense_sheet, beginning: beginning, ending: ending) }
  end

  describe '#destroy' do
    before { create :service, user: user }

    let(:user) { create :user }
    let!(:expense_sheet) { create :expense_sheet, user: user }

    context 'when the expense sheet is not already paid' do
      it 'destroys the expense_sheet' do
        expect { expense_sheet.destroy }.to change(described_class, :count).by(-1)
      end
    end

    context 'when the expense sheet is already paid' do
      let!(:expense_sheet) { create :expense_sheet, :paid }

      it 'does not destroy the expense_sheet' do
        expect { expense_sheet.destroy }.not_to change(described_class, :count)
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
    subject(:expense_sheet) { build(:expense_sheet).duration }

    it { is_expected.to eq 26 }
  end

  describe '#total_paid_vacation_days' do
    subject { expense_sheet.total_paid_vacation_days }

    before { create :service, user: user }

    let(:user) { create :user }
    let(:expense_sheet) do
      create :expense_sheet,
             paid_vacation_days: 2, paid_company_holiday_days: 1, unpaid_company_holiday_days: 3, user: user
    end

    it { is_expected.to eq 3 }
  end

  describe '#at_service_beginning?' do
    let(:user) { create :user }
    let!(:service) { create :service, service_data.merge(user: user) }
    let(:expense_sheet) { create :expense_sheet, expense_sheet_data.merge(user: user) }

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
          work_days: 23
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

  describe 'update' do
    context 'when state is paid' do
      let!(:service) { create :service }
      let(:expense_sheet) { create :expense_sheet, :paid, user: service.user }

      it 'prevents an update' do
        expect { expense_sheet.update(sick_comment: 'blubb') }.to raise_error ActiveRecord::ReadOnlyRecord
      end
    end

    context 'when updating to paid state' do
      let(:expense_sheet) { create :expense_sheet, :payment_in_progress }

      it 'prevents an update' do
        expect { expense_sheet.update(state: 'paid') }.not_to raise_error
      end
    end

    context 'when state is not paid' do
      let(:expense_sheet) { create :expense_sheet, :payment_in_progress }

      it 'prevents an update' do
        expect { expense_sheet.update(sick_comment: 'blubb') }.not_to raise_error
      end
    end
  end
end
