# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetGenerator, type: :service do
  let(:service) { create :service, :long, beginning: '2018-01-01', ending: '2018-06-29' }
  let(:expense_sheet_generator) { described_class.new(service) }

  describe '#create_expense_sheets' do
    let(:create_expense_sheets) { expense_sheet_generator.create_expense_sheets }

    it 'creates 6 new expense sheets' do
      expect { create_expense_sheets }.to change(ExpenseSheet, :count).by(6)
    end

    it 'sets constant bank_account_number', :aggregate_failures do
      create_expense_sheets
      ExpenseSheet.all.each do |expense_sheet|
        expect(expense_sheet.credited_iban).to eq expense_sheet.service.civil_servant.iban
      end
    end

    it 'sets correct civil_servants', :aggregate_failures do
      create_expense_sheets
      ExpenseSheet.all.each do |expense_sheet|
        expect(expense_sheet.service.civil_servant).to eq service.civil_servant
      end
    end

    context 'with a single month service' do
      let(:service) { create :service, beginning: '2018-01-01', ending: '2018-01-26' }

      it 'creates one new expense sheet' do
        expect do
          expense_sheet_generator.create_expense_sheets beginning: service.beginning, ending: service.ending
        end.to change(ExpenseSheet, :count).by(1)
      end

      it 'creates the correct ExpenseSheet', :aggregate_failures do
        create_expense_sheets
        expect(ExpenseSheet.first.beginning).to eq Date.parse('2018-01-01')
        expect(ExpenseSheet.first.ending).to eq Date.parse('2018-01-26')
        expect(ExpenseSheet.first.work_days).to eq 19
        expect(ExpenseSheet.first.workfree_days).to eq 7
      end
    end

    context 'with a multi month service' do
      before do
        create :organization_holiday, beginning: '2018-02-23', ending: '2018-03-05'
        create :organization_holiday, beginning: '2018-04-05', ending: '2018-04-15'
        create :organization_holiday, beginning: '2018-05-17', ending: '2018-05-20'

        create_expense_sheets
      end

      let(:expected_expense_sheets_values) do
        {
          first: {
            beginning: Date.parse('2018-01-01'),
            ending: Date.parse('2018-01-31'),
            work_days: 22,
            workfree_days: 9
          },
          second: {
            beginning: Date.parse('2018-02-01'),
            ending: Date.parse('2018-02-28'),
            work_days: 16,
            workfree_days: 8
          },
          third: {
            beginning: Date.parse('2018-03-01'),
            ending: Date.parse('2018-03-31'),
            work_days: 19,
            workfree_days: 9
          },
          fourth: {
            beginning: Date.parse('2018-04-01'),
            ending: Date.parse('2018-04-30'),
            work_days: 14,
            workfree_days: 9
          },
          fifth: {
            beginning: Date.parse('2018-05-01'),
            ending: Date.parse('2018-05-31'),
            work_days: 20,
            workfree_days: 9
          },
          last: {
            beginning: Date.parse('2018-06-01'),
            ending: Date.parse('2018-06-29'),
            work_days: 21,
            workfree_days: 8
          }
        }
      end

      it 'creates all the ExpenseSheets correctly', :aggregate_failures do
        expected_expense_sheets_values.each do |sheet_key, expected_values|
          expected_values.each do |value_key, expected_value|
            expect(ExpenseSheet.public_send(sheet_key).public_send(value_key)).to eq expected_value
          end
        end
      end
    end
  end

  describe '#create_missing_expense_sheets' do
    let(:create_missing_expense_sheets) { expense_sheet_generator.create_missing_expense_sheets }

    context 'when there are previous expense_sheets' do
      before do
        expense_sheet_generator.create_expense_sheets
        service.update ending: service.ending + 28.days
      end

      context 'when create_expense_sheets is mocked' do
        before { allow(expense_sheet_generator).to receive(:create_expense_sheets) }

        it 'calls create_expense_sheets with the correct arguments' do
          create_missing_expense_sheets
          expect(expense_sheet_generator)
            .to have_received(:create_expense_sheets).with(beginning: Date.parse('2018-06-30'))
        end
      end

      it 'creates 2 new expense sheets' do
        expect { create_missing_expense_sheets }.to change(ExpenseSheet, :count).by(2)
      end
    end

    context 'when there are no previous expense_sheets' do
      before { allow(expense_sheet_generator).to receive(:create_expense_sheets) }

      it 'calls create_expense_sheets with the correct arguments' do
        create_missing_expense_sheets
        expect(expense_sheet_generator).to have_received(:create_expense_sheets).with(no_args)
      end
    end
  end

  describe '#create_additional_expense_sheet' do
    let(:create_additional_expense_sheet) { expense_sheet_generator.create_additional_expense_sheet }

    before { expense_sheet_generator.create_expense_sheets }

    context 'when create_expense_sheets is mocked' do
      before { allow(expense_sheet_generator).to receive(:create_expense_sheet) }

      it 'calls create_expense_sheets with the correct arguments' do
        create_additional_expense_sheet
        expect(expense_sheet_generator)
          .to have_received(:create_expense_sheet).with(service.ending, service.ending)
      end
    end

    it 'creates a new expense_sheet' do
      expect { create_additional_expense_sheet }.to change(ExpenseSheet, :count).by(1)
    end
  end
end
