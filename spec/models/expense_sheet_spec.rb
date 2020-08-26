# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheet, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations correctly' do
      expect(model).to belong_to(:service)
      expect(model).to belong_to(:payment).optional
      expect(model).to have_one(:service_specification).through(:service)
    end
  end

  describe 'validations' do
    before { build :service, civil_servant: civil_servant }

    let(:civil_servant) { create :civil_servant, :full }
    let(:expense_sheet) { build :expense_sheet }

    let(:present_fields) do
      %i[beginning ending work_days state]
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

    it 'validates that required fields are present' do
      present_fields.each do |field|
        expect(expense_sheet).to validate_presence_of field
      end
    end

    it 'validates the correctness of numerical fields correctly' do
      only_integer_fields.each do |field|
        expect(expense_sheet).to validate_numericality_of(field).only_integer.is_greater_than_or_equal_to(0)
      end
    end

    describe '#included_in_service_date_range' do
      let(:beginning) { Date.parse('2019-09-02') }
      let(:ending) { Date.parse('2019-09-27') }

      let(:civil_servant) { create :civil_servant, :full }
      let(:service) { create :service, civil_servant: civil_servant, beginning: beginning, ending: ending }

      context 'when expense_sheet is in service period' do
        subject(:expense_sheet) do
          build(:expense_sheet, service: service, beginning: beginning, ending: ending).tap(&:validate)
        end

        it 'is valid' do
          expect(expense_sheet.errors[:base]).to be_empty
        end
      end

      context 'when expense_sheet is outside service period' do
        subject(:expense_sheet) do
          build(:expense_sheet, :with_service, beginning: invalid_beginning, ending: invalid_ending).tap(&:validate)
        end

        let(:invalid_beginning) { Date.parse('2019-09-28') }
        let(:invalid_ending) { Date.parse('2019-09-28') }

        it 'added error' do
          expect(expense_sheet.errors[:base]).to(
            include I18n.t('activerecord.errors.models.expense_sheet.outside_service_date_range')
          )
        end
      end
    end

    describe '#sum_of_days_not_greater_than_duration' do
      let(:expense_sheet) { build(:expense_sheet, work_days: work_days, sick_days: sick_days) }
      let(:sick_days) { 0 }

      context 'when expense sheet sum of days is smaller than expense sheet duration' do
        let(:work_days) { 23 }

        it 'is valid' do
          expect(expense_sheet.tap(&:validate).errors[:base]).to be_empty
        end
      end
    #
      context 'when expense sheet sum of days is equal to the expense sheet duration' do
        let(:work_days) { 24 }

        it 'is valid' do
          expect(expense_sheet.tap(&:validate).errors[:base]).to be_empty
        end
      end

      context 'when expense sheet sum of days is greater than the expense sheet duration' do
        let(:work_days) { 26 }
        let(:sick_days) { 3 }

        it 'added error' do
          expect(expense_sheet.tap(&:validate).errors[:base]).to(
            include I18n.t('activerecord.errors.models.expense_sheet.sum_of_days_greater_than_duration')
          )
        end
      end
    end

    it_behaves_like 'validates that the ending is on or after beginning' do
      let(:model) { build(:expense_sheet, beginning: beginning, ending: ending) }
    end
  end

  describe '#destroy' do
    before { create :service, civil_servant: civil_servant }

    let(:civil_servant) { create :civil_servant, :full }
    let!(:expense_sheet) { create :expense_sheet, :with_service }

    context 'when the expense sheet is not already paid' do
      it 'destroys the expense_sheet' do
        expect { expense_sheet.destroy }.to change(described_class, :count).by(-1)
      end
    end

    context 'when the expense sheet is already paid' do
      let!(:expense_sheet) { create :expense_sheet, :with_service, :closed }

      it 'does not destroy the expense_sheet' do
        expect { expense_sheet.destroy }.not_to change(described_class, :count)
      end

      it 'returns an error' do
        expense_sheet.destroy
        expect(expense_sheet.errors[:base]).to include(I18n.t('activerecord.errors.models.expense_sheet.already_paid'))
      end
    end
  end

  describe '#state' do
    subject { !expense_sheet.errors.added?(:state, :invalid_state_change) }

    before { expense_sheet.update(state: state) }

    let(:civil_servant) { create :civil_servant, :full }
    let(:expense_sheet) do
      create(:expense_sheet, :with_service).tap do |sheet|
        sheet.state = state_was
        sheet.save(validate: false)
      end
    end

    context 'when state was locked' do
      let(:state_was) { :locked }

      context 'when new state is editable' do
        let(:state) { :editable }

        it { is_expected.to eq true }
      end

      context 'when new state is closed' do
        let(:state) { :closed }

        it { is_expected.to eq false }
      end
    end

    context 'when state was editable' do
      let(:state_was) { :editable }

      context 'when new state is closed' do
        let(:state) { :closed }

        it { is_expected.to eq true }
      end

      context 'when new state is locked' do
        let(:state) { :locked }

        it { is_expected.to eq false }
      end
    end

    context 'when state was closed' do
      let(:state_was) { :closed }

      context 'when new state is editable' do
        let(:state) { :editable }

        it { is_expected.to eq false }
      end

      context 'when new state is locked' do
        let(:state) { :locked }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#duration' do
    subject(:expense_sheet) { build(:expense_sheet, :with_service).duration }

    it { is_expected.to eq 26 }
  end

  describe '#total_paid_vacation_days' do
    subject { expense_sheet.total_paid_vacation_days }

    let(:expense_sheet) do
      build(:expense_sheet,
             :with_service,
             paid_vacation_days: 2,
             paid_company_holiday_days: 1,
             unpaid_company_holiday_days: 3)
    end

    it { is_expected.to eq 3 }
  end

  describe '#at_service_beginning?' do
    let(:civil_servant) { create :civil_servant, :full }
    let!(:service) { create :service, service_data.merge(civil_servant: civil_servant) }
    let(:expense_sheet) { create :expense_sheet, :with_service, expense_sheet_data }

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
          service: service,
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
          service: service,
          work_days: 23
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
          service: service,
          work_days: 3
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
          service: service,
          work_days: 23
        }
      end

      it 'returns false' do
        expect(expense_sheet.at_service_ending?).to eq false
      end
    end
  end

  describe 'update' do
    context 'when state is closed' do
      let!(:service) { create :service }
      let(:expense_sheet) { create :expense_sheet, :closed, service: service }

      it 'prevents an update' do
        expect { expense_sheet.update(sick_comment: 'blubb') }.to raise_error ActiveRecord::ReadOnlyRecord
      end
    end

    context 'when updating to closed state' do
      let(:expense_sheet) { create :expense_sheet, :with_service }

      it 'prevents an update' do
        expect { expense_sheet.update(state: :closed) }.not_to raise_error
      end
    end
  end
end
