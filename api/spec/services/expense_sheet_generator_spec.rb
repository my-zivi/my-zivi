# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetGenerator, type: :service do
  subject { -> { create_expense_sheets } }

  let(:service) { create :service, :long, beginning: '2018-01-01', ending: '2018-06-29' }
  let(:expense_sheet_generator) { ExpenseSheetGenerator.new(service) }
  let(:create_expense_sheets) { expense_sheet_generator.create_expense_sheets }

  describe '#create_expense_sheets' do
    it { is_expected.to change(ExpenseSheet, :count).by(6) }

    it 'sets constant bank_account_number', :aggregate_failures do
      ExpenseSheet.all.each do |expense_sheet|
        expect(expense_sheet.bank_account_number).to eq '4470 (200)'
      end
    end

    it 'sets correct user', :aggregate_failures do
      ExpenseSheet.all.each do |expense_sheet|
        expect(expense_sheet.user).to eq service.user
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
        create :holiday, beginning: '2018-02-23', ending: '2018-03-05'
        create :holiday, beginning: '2018-04-05', ending: '2018-04-15'
        create :holiday, beginning: '2018-05-17', ending: '2018-05-20'

        create :holiday, :public_holiday, beginning: '2018-01-15', ending: '2018-01-20'
        create :holiday, :public_holiday, beginning: '2018-02-28', ending: '2018-03-03'
        create :holiday, :public_holiday, beginning: '2018-06-01', ending: '2018-06-20'

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
end
