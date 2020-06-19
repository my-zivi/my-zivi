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

    it 'sets correct civil_servant', :aggregate_failures do
      create_expense_sheets
      ExpenseSheet.all.each do |expense_sheet|
        expect(expense_sheet.civil_servant).to eq service.civil_servant
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
        expect(ExpenseSheet.first.work_days).to eq 20
        expect(ExpenseSheet.first.workfree_days).to eq 6
      end
    end

    context 'when there are no holidays' do
      before { create_expense_sheets }

      it 'creates the correct first ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.first.beginning).to eq Date.parse('2018-01-01')
        expect(ExpenseSheet.first.ending).to eq Date.parse('2018-01-31')
        expect(ExpenseSheet.first.work_days).to eq 23
        expect(ExpenseSheet.first.workfree_days).to eq 8
      end

      it 'creates the correct second ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.second.beginning).to eq Date.parse('2018-02-01')
        expect(ExpenseSheet.second.ending).to eq Date.parse('2018-02-28')
        expect(ExpenseSheet.second.work_days).to eq 20
        expect(ExpenseSheet.second.workfree_days).to eq 8
      end

      it 'creates the correct third ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.third.beginning).to eq Date.parse('2018-03-01')
        expect(ExpenseSheet.third.ending).to eq Date.parse('2018-03-31')
        expect(ExpenseSheet.third.work_days).to eq 22
        expect(ExpenseSheet.third.workfree_days).to eq 9
      end

      it 'creates the correct fourth ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.fourth.beginning).to eq Date.parse('2018-04-01')
        expect(ExpenseSheet.fourth.ending).to eq Date.parse('2018-04-30')
        expect(ExpenseSheet.fourth.work_days).to eq 21
        expect(ExpenseSheet.fourth.workfree_days).to eq 9
      end

      it 'creates the correct fifth ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.fifth.beginning).to eq Date.parse('2018-05-01')
        expect(ExpenseSheet.fifth.ending).to eq Date.parse('2018-05-31')
        expect(ExpenseSheet.fifth.work_days).to eq 23
        expect(ExpenseSheet.fifth.workfree_days).to eq 8
      end

      it 'creates the correct sixth ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.last.beginning).to eq Date.parse('2018-06-01')
        expect(ExpenseSheet.last.ending).to eq Date.parse('2018-06-29')
        expect(ExpenseSheet.last.work_days).to eq 21
        expect(ExpenseSheet.last.workfree_days).to eq 8
      end
    end

    context 'when there are holidays' do
      before do
        create :organization_holiday, beginning: '2018-02-23', ending: '2018-03-05'
        create :organization_holiday, beginning: '2018-04-05', ending: '2018-04-15'
        create :organization_holiday, beginning: '2018-05-17', ending: '2018-05-20'

        create_expense_sheets
      end

      it 'creates the correct first ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.first.beginning).to eq Date.parse('2018-01-01')
        expect(ExpenseSheet.first.ending).to eq Date.parse('2018-01-31')
        expect(ExpenseSheet.first.work_days).to eq 18
        expect(ExpenseSheet.first.workfree_days).to eq 13
      end

      it 'creates the correct second ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.second.beginning).to eq Date.parse('2018-02-01')
        expect(ExpenseSheet.second.ending).to eq Date.parse('2018-02-28')
        expect(ExpenseSheet.second.work_days).to eq 16
        expect(ExpenseSheet.second.workfree_days).to eq 9
      end

      it 'creates the correct third ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.third.beginning).to eq Date.parse('2018-03-01')
        expect(ExpenseSheet.third.ending).to eq Date.parse('2018-03-31')
        expect(ExpenseSheet.third.work_days).to eq 19
        expect(ExpenseSheet.third.workfree_days).to eq 11
      end

      it 'creates the correct fourth ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.fourth.beginning).to eq Date.parse('2018-04-01')
        expect(ExpenseSheet.fourth.ending).to eq Date.parse('2018-04-30')
        expect(ExpenseSheet.fourth.work_days).to eq 14
        expect(ExpenseSheet.fourth.workfree_days).to eq 9
      end

      it 'creates the correct fifth ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.fifth.beginning).to eq Date.parse('2018-05-01')
        expect(ExpenseSheet.fifth.ending).to eq Date.parse('2018-05-31')
        expect(ExpenseSheet.fifth.work_days).to eq 21
        expect(ExpenseSheet.fifth.workfree_days).to eq 8
      end

      it 'creates the correct sixth ExpenseSheet', :aggregate_failures do
        expect(ExpenseSheet.last.beginning).to eq Date.parse('2018-06-01')
        expect(ExpenseSheet.last.ending).to eq Date.parse('2018-06-29')
        expect(ExpenseSheet.last.work_days).to eq 7
        expect(ExpenseSheet.last.workfree_days).to eq 22
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
          expect(expense_sheet_generator).to have_received(:create_expense_sheets)
            .with(beginning: Date.parse('2018-06-30'))
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
        expect(expense_sheet_generator).to have_received(:create_expense_sheet)
          .with(service.ending, service.ending)
      end
    end

    it 'creates a new expense_sheet' do
      expect { create_additional_expense_sheet }.to change(ExpenseSheet, :count).by(1)
    end
  end
end
