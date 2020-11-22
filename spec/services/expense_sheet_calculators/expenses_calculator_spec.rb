# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetCalculators::ExpensesCalculator, type: :service do
  let(:calculator) { described_class.new(expense_sheet) }

  let(:service_specification) { build(:service_specification, identification_number: 82_846) }
  let(:service) do
    build(:service,
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-08-03'),
          service_specification: service_specification)
  end

  let(:expense_sheet) do
    build(:expense_sheet,
          beginning: Date.parse('2018-03-01'),
          ending: Date.parse('2018-03-31'),
          service: service,
          **expense_sheet_data)
  end

  let(:expense_sheet_data) { { work_days: 22 } }

  let(:default_expected_values) do
    {
      accommodation: 0,
      breakfast: 4,
      dinner: 7,
      lunch: 9,
      pocket_money: 5,
      total: 25
    }
  end

  context 'when it is normal' do
    describe '#calculate_first_day' do
      subject { calculator.calculate_first_day }

      it { is_expected.to eq default_expected_values.merge(breakfast: 0, total: 0) }
    end

    describe '#calculate_work_days' do
      subject { calculator.calculate_work_days }

      it { is_expected.to eq default_expected_values.merge(total: 550) }
    end

    describe '#calculate_last_day' do
      subject { calculator.calculate_last_day }

      it { is_expected.to eq default_expected_values.merge(dinner: 0, total: 0) }
    end

    describe '#calculate_workfree_days' do
      let(:expected_values) { default_expected_values.merge(total: 50) }

      it 'returns correct values' do
        expect(calculator.calculate_workfree_days).to eq expected_values
      end
    end

    describe '#calculate_sick_days' do
      context 'when there are no sick days' do
        subject { calculator.calculate_sick_days }

        it { is_expected.to eq default_expected_values.merge(total: 0) }
      end

      context 'when there are sick days' do
        subject { calculator.calculate_sick_days }

        let(:expense_sheet_data) { { work_days: 20, sick_days: 2 } }

        it { is_expected.to eq default_expected_values.merge(total: 50) }
      end
    end

    describe '#calculate_paid_vacation_days' do
      subject { calculator.calculate_paid_vacation_days }

      it { is_expected.to eq default_expected_values.merge(total: 0) }
    end

    describe '#calculate_unpaid_vacation_days' do
      subject { calculator.calculate_unpaid_vacation_days }

      let(:expected_values) do
        {
          pocket_money: 0,
          accommodation: 0,
          breakfast: 0,
          lunch: 0,
          dinner: 0,
          total: 0
        }
      end

      it { is_expected.to eq expected_values }
    end

    describe '#calculate_full_expenses' do
      subject { calculator.calculate_full_expenses }

      it { is_expected.to eq 652 }

      context 'when there is custom expenses' do
        let(:expense_sheet_data) { { clothing_expenses: 32.5, driving_expenses: 22.3, work_days: 22 } }

        it { is_expected.to eq 654.8 }
      end
    end

    describe '#calculate_chargeable_days' do
      before do
        expense_sheet.unpaid_company_holiday_days = 1
        expense_sheet.unpaid_vacation_days = 2
      end

      it 'returns correct number of chargeable days' do
        expect(calculator.calculate_chargeable_days).to eq 28
      end
    end
  end

  context 'when is at the beginning' do
    let(:expense_sheet_data) do
      {
        beginning: Date.parse('2018-01-01'),
        ending: Date.parse('2018-01-31'),
        work_days: 23,
        service: service
      }
    end

    describe '#calculate_first_day' do
      subject { calculator.calculate_first_day }

      it { is_expected.to eq default_expected_values.merge(breakfast: 0, total: 21) }
    end
  end

  context 'when it is at the ending' do
    let(:expense_sheet_data) do
      {
        beginning: Date.parse('2018-08-01'),
        ending: Date.parse('2018-08-03'),
        work_days: 3,
        workfree_days: 0,
        service: service
      }
    end

    describe '#calculate_last_day' do
      subject { calculator.calculate_last_day }

      it { is_expected.to eq default_expected_values.merge(dinner: 0, total: 18) }
    end
  end
end
