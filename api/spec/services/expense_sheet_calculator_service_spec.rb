# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetCalculatorService, type: :service do
  let(:calculator) { ExpenseSheetCalculatorService.new(expense_sheet) }

  let(:expense_sheet) { create :expense_sheet, expense_sheet_data }
  let(:service) { create :service, service_data }
  let(:service_specification) { create :service_specification, identification_number: 82_846 }
  let(:expense_sheet_data) do
    {
      beginning: Date.parse('2018-03-01'),
      ending: Date.parse('2018-03-31'),
      work_days: 22,
      user: service.user
    }
  end
  let(:service_data) do
    {
      beginning: Date.parse('2018-01-01'),
      ending: Date.parse('2018-08-03'),
      service_specification: service_specification
    }
  end

  let(:default_expected_values) do
    {
      accommodation: 0,
      breakfast: 400,
      dinner: 700,
      lunch: 900,
      pocket_money: 500,
      total: 2500
    }
  end

  context 'when it is normal' do
    describe '#calculate_first_day' do
      let(:expected_values) { default_expected_values.merge(breakfast: 0, total: 0) }

      it 'returns correct values' do
        expect(calculator.calculate_first_day).to eq expected_values
      end
    end

    describe '#calculate_work_days' do
      let(:expected_values) { default_expected_values.merge(total: 55_000) }

      it 'returns correct values' do
        expect(calculator.calculate_work_days).to eq expected_values
      end
    end

    describe '#calculate_last_day' do
      let(:expected_values) { default_expected_values.merge(dinner: 0, total: 0) }

      it 'returns correct values' do
        expect(calculator.calculate_last_day).to eq expected_values
      end
    end

    describe '#calculate_workfree_days' do
      let(:expected_values) { default_expected_values.merge(total: 5000) }

      it 'returns correct values' do
        expect(calculator.calculate_workfree_days).to eq expected_values
      end
    end

    describe '#calculate_sick_days' do
      context 'when there are no sick days' do
        let(:expected_values) { default_expected_values.merge(total: 0) }

        it 'returns correct values' do
          expect(calculator.calculate_sick_days).to eq expected_values
        end
      end

      context 'when there are sick days' do
        let(:expense_sheet) do
          create :expense_sheet, expense_sheet_data.merge(work_days: 20, sick_days: 2)
        end
        let(:expected_values) { default_expected_values.merge(total: 5000) }

        it 'returns correct values' do
          expect(calculator.calculate_sick_days).to eq expected_values
        end
      end
    end

    describe '#calculate_paid_vacation_days' do
      let(:expected_values) { default_expected_values.merge(total: 0) }

      it 'returns correct values' do
        expect(calculator.calculate_paid_vacation_days).to eq expected_values
      end
    end

    describe '#calculate_unpaid_vacation_days' do
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

      it 'returns correct values' do
        expect(calculator.calculate_unpaid_vacation_days).to eq expected_values
      end
    end

    describe '#calculate_full_expenses' do
      let(:expected_values) { 65_200 }

      it 'returns correct values' do
        expect(calculator.calculate_full_expenses).to eq expected_values
      end
    end

    describe '#calculate_chargeable_days' do
      it 'returns correct number of chareable days' do
        expect(calculator.calculate_chargeable_days).to eq 31
      end
    end
  end

  context 'when is at the beginning' do
    let(:expense_sheet_data) do
      {
        beginning: Date.parse('2018-01-01'),
        ending: Date.parse('2018-01-31'),
        work_days: 23,
        user: service.user
      }
    end

    describe '#calculate_first_day' do
      let(:expected_values) { default_expected_values.merge(breakfast: 0, total: 2100) }

      it 'returns correct values' do
        expect(calculator.calculate_first_day).to eq expected_values
      end
    end
  end

  context 'when it is at the ending' do
    let(:expense_sheet_data) do
      {
        beginning: Date.parse('2018-08-01'),
        ending: Date.parse('2018-08-03'),
        work_days: 3,
        user: service.user
      }
    end

    describe '#calculate_last_day' do
      let(:expected_values) { default_expected_values.merge(dinner: 0, total: 1800) }

      it 'returns correct values' do
        expect(calculator.calculate_last_day).to eq expected_values
      end
    end
  end
end
