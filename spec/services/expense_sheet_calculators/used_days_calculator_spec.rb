# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetCalculators::UsedDaysCalculator, type: :service do
  let(:calculator) { described_class.new(service) }
  let(:service_range) { get_service_range months: 3 }
  let(:beginning) { service_range.begin }
  let(:ending) { service_range.end }
  let(:created_expense_sheets) { ExpenseSheetGenerator.new(service).create_expense_sheets! }
  let(:service) do
    build(:service, beginning: beginning, ending: ending, organization: create(:organization, :with_admin))
  end

  let(:payment) { nil }
  let(:sick_days_per_sheet) { 0 }
  let(:state) { :editable }
  let(:paid_vacation_days) { 0 }
  let(:paid_company_holiday_days) { 0 }

  before do
    created_expense_sheets.each do |expense_sheet|
      expense_sheet.sick_days = sick_days_per_sheet
      expense_sheet.payment = payment
      expense_sheet.paid_vacation_days = paid_vacation_days
      expense_sheet.paid_company_holiday_days = paid_company_holiday_days
      set_expense_sheet_state_to expense_sheet, state
    end
  end

  describe '#used_sick_days' do
    subject { calculator.used_sick_days }

    context 'with no relevant_for_calculations expense_sheets' do
      let(:sick_days_per_sheet) { 10 }

      it { is_expected.to eq 0 }
    end

    context 'with relevant_for_calculations expense_sheets' do
      let(:sick_days_per_sheet) { 0 }
      let(:payment) { create :payment }
      let(:state) { :closed }

      context 'with no previous sick_days' do
        it { is_expected.to eq 0 }
      end

      context 'with previous sick_days' do
        let(:sick_days) { 2 }

        it { is_expected.to eq sick_days_per_sheet * created_expense_sheets.length }
      end
    end

    describe 'scope usage' do
      before { allow(service.expense_sheets).to receive(:relevant_for_calculations).and_return [] }

      it 'uses the ExpenseSheets#relevant_for_calculations scope' do
        calculator.used_sick_days
        expect(service.expense_sheets).to have_received(:relevant_for_calculations)
      end
    end
  end

  describe '#used_paid_vacation_days' do
    subject { calculator.used_paid_vacation_days }

    context 'with no relevant_for_calculations expense_sheets' do
      let(:paid_vacation_days) { 2 }
      let(:paid_company_holiday_days) { 3 }

      it { is_expected.to eq 0 }
    end

    context 'with relevant_for_calculations expense_sheets' do
      let(:state) { :closed }

      context 'with no previous paid_vacation_days or paid_company_holiday_days' do
        it { is_expected.to eq 0 }
      end

      context 'with previous paid_vacation_days' do
        let(:paid_vacation_days) { 2 }

        it { is_expected.to eq 6 }
      end

      context 'with previous paid_company_holiday_days' do
        let(:paid_company_holiday_days) { 3 }

        it { is_expected.to eq 9 }
      end

      context 'with previous paid_vacation_days and paid_company_holiday_days' do
        let(:paid_vacation_days) { 1 }
        let(:paid_company_holiday_days) { 2 }

        it { is_expected.to eq 9 }
      end
    end

    describe 'scope usage' do
      before { allow(service.expense_sheets).to receive(:relevant_for_calculations).and_return [] }

      it 'uses the ExpenseSheets#relevant_for_calculations scope' do
        calculator.used_paid_vacation_days
        expect(service.expense_sheets).to have_received(:relevant_for_calculations)
      end
    end
  end
end
