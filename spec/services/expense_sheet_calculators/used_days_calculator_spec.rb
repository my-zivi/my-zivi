# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetCalculators::UsedDaysCalculator, type: :service do
  let(:calculator) { described_class.new(service) }
  let(:service_range) { get_service_range months: 3 }
  let(:beginning) { service_range.begin }
  let(:ending) { service_range.end }
  let(:service) { create :service, beginning: beginning, ending: ending }
  let(:created_expense_sheets) { ExpenseSheetGenerator.new(service).create_expense_sheets }

  describe '#used_sick_days' do
    subject { calculator.used_sick_days }

    context 'with no relevant_for_calculations expense_sheets' do
      before { created_expense_sheets.each { |expense_sheet| expense_sheet.update sick_days: 10 } }

      it { is_expected.to eq 0 }
    end

    context 'with relevant_for_calculations expense_sheets' do
      before { created_expense_sheets.each { |expense_sheet| expense_sheet.update state: :ready_for_payment } }

      context 'with no previous sick_days' do
        it { is_expected.to eq 0 }
      end

      context 'with previous sick_days' do
        let(:sick_days_per_sheet) { 2 }

        before { created_expense_sheets.each { |expense_sheet| expense_sheet.update sick_days: sick_days_per_sheet } }

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
      before do
        created_expense_sheets.each do |expense_sheet|
          expense_sheet.update paid_vacation_days: 2, paid_company_holiday_days: 3
        end
      end

      it { is_expected.to eq 0 }
    end

    context 'with relevant_for_calculations expense_sheets' do
      before { created_expense_sheets.each { |expense_sheet| expense_sheet.update state: :ready_for_payment } }

      context 'with no previous paid_vacation_days or paid_company_holiday_days' do
        it { is_expected.to eq 0 }
      end

      context 'with previous paid_vacation_days' do
        before { created_expense_sheets.take(2).each { |expense_sheet| expense_sheet.update paid_vacation_days: 2 } }

        it { is_expected.to eq 4 }
      end

      context 'with previous paid_company_holiday_days' do
        before do
          created_expense_sheets.take(2).each { |expense_sheet| expense_sheet.update paid_company_holiday_days: 2 }
        end

        it { is_expected.to eq 4 }
      end

      context 'with previous paid_vacation_days and paid_company_holiday_days' do
        before do
          created_expense_sheets.first.update paid_vacation_days: 1, paid_company_holiday_days: 3
          created_expense_sheets.second.update paid_vacation_days: 2
          created_expense_sheets.third.update paid_company_holiday_days: 1
        end

        it { is_expected.to eq 7 }
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
