# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetCalculators::SuggestionsCalculator, type: :service do
  let(:calculator) { described_class.new(expense_sheet) }
  let(:civil_servant) { create :civil_servant, :full }
  let(:beginning) { Date.parse('2018-01-01') }
  let(:ending) { Date.parse('2018-01-26') }
  let!(:service) { create :service, beginning: beginning, ending: ending, civil_servant: civil_servant }
  let(:expense_sheet) { create :expense_sheet, beginning: beginning, ending: ending, civil_servant: civil_servant }

  let(:expected_work_days) { 20 }
  let(:expected_workfree_days) { 6 }

  describe '#suggestions' do
    subject { calculator.suggestions }

    let(:expected_suggestions) do
      {
        clothing_expenses: 5980,
        paid_company_holiday_days: 0,
        unpaid_company_holiday_days: 0,
        work_days: 20,
        workfree_days: 6
      }
    end

    it { is_expected.to eq expected_suggestions }
  end

  describe '#suggested_work_days' do
    let(:day_calculator) { instance_double(DayCalculator, calculate_work_days: expected_work_days) }

    before { allow(DayCalculator).to receive(:new).and_return day_calculator }

    it 'delegates the correct method', :aggregate_failures do
      expect(calculator.suggested_work_days).to eq expected_work_days
      expect(day_calculator).to have_received :calculate_work_days
    end
  end

  describe '#suggested_workfree_days' do
    let(:day_calculator) { instance_double(DayCalculator, calculate_workfree_days: expected_workfree_days) }

    before { allow(DayCalculator).to receive(:new).and_return day_calculator }

    it 'delegates the correct method', :aggregate_failures do
      expect(calculator.suggested_workfree_days).to eq expected_workfree_days
      expect(day_calculator).to have_received :calculate_workfree_days
    end
  end

  describe '#suggested_paid_company_holiday_days' do
    subject { calculator.suggested_paid_company_holiday_days }

    let(:remaining_paid_vacation_days) { 0 }
    let(:company_holiday_days) { 0 }
    let(:day_calculator) { instance_double(DayCalculator, calculate_company_holiday_days: company_holiday_days) }

    before do
      allow(expense_sheet.service).to receive(:remaining_paid_vacation_days).and_return remaining_paid_vacation_days

      allow(DayCalculator).to receive(:new).and_return day_calculator
    end

    context 'with remaining_paid_vacation_days' do
      let(:remaining_paid_vacation_days) { 8 }

      context 'with no company holidays' do
        it { is_expected.to eq 0 }
      end

      context 'with company holidays' do
        let(:company_holiday_days) { 2 }

        it { is_expected.to eq company_holiday_days }
      end

      context 'with more company holiday days than remaining_paid_vacation_days' do
        let(:company_holiday_days) { 10 }

        it { is_expected.to eq remaining_paid_vacation_days }
      end
    end

    context 'with no remaining_paid_vacation_days' do
      context 'with no company holidays' do
        it { is_expected.to eq 0 }
      end

      context 'with company holidays' do
        let(:company_holiday_days) { 2 }

        it { is_expected.to eq 0 }
      end
    end
  end

  describe '#suggested_unpaid_company_holiday_days' do
    subject { calculator.suggested_unpaid_company_holiday_days }

    let(:remaining_paid_vacation_days) { 0 }
    let(:company_holiday_days) { 0 }
    let(:day_calculator) { instance_double(DayCalculator, calculate_company_holiday_days: company_holiday_days) }

    before do
      allow(expense_sheet.service).to receive(:remaining_paid_vacation_days).and_return remaining_paid_vacation_days

      allow(DayCalculator).to receive(:new).and_return day_calculator
    end

    context 'with remaining_paid_vacation_days' do
      let(:remaining_paid_vacation_days) { 8 }

      context 'with no company holidays' do
        it { is_expected.to eq 0 }
      end

      context 'with company holidays' do
        let(:company_holiday_days) { 2 }

        it { is_expected.to eq 0 }
      end

      context 'with more company holiday days than remaining_paid_vacation_days' do
        let(:company_holiday_days) { 10 }

        it { is_expected.to eq 2 }
      end
    end

    context 'with no remaining_paid_vacation_days' do
      context 'with no company holidays' do
        it { is_expected.to eq 0 }
      end

      context 'with company holidays' do
        let(:company_holiday_days) { 2 }

        it { is_expected.to eq 2 }
      end
    end
  end

  describe '#suggested_clothing_expenses' do
    subject { calculator.suggested_clothing_expenses }

    let(:daily_expenses) { service.service_specification.work_clothing_expenses }
    let(:chargeable_days) { expense_sheet.calculate_chargeable_days }
    let(:expected_value) { daily_expenses * chargeable_days }

    context 'with only one expense sheet' do
      it { is_expected.to eq 5980 }
    end

    context 'with more than one expense sheet' do
      let(:service_range) { get_service_range months: 3 }
      let(:service) { create :service, beginning: service_range.begin, ending: service_range.end, civil_servant: civil_servant }
      let(:created_expense_sheets) { ExpenseSheetGenerator.new(service).create_expense_sheets }
      let(:expense_sheet) { created_expense_sheets.last }

      before do
        additional_expense_sheets = created_expense_sheets.length - 1
        created_expense_sheets.take(additional_expense_sheets).each do |expense_sheet|
          clothing_expenses = expense_sheet.calculate_chargeable_days * daily_expenses
          expense_sheet.update clothing_expenses: clothing_expenses
        end
      end

      context 'with enough expense_sheets to reduce clothing_expenses' do
        let(:service_range) { get_service_range months: 4 }

        it { is_expected.to eq 3300 }
      end

      context 'with enough expense_sheets to nullify clothing_expenses' do
        let(:service_range) { get_service_range months: 5 }

        it { is_expected.to eq 0 }
      end
    end
  end
end
