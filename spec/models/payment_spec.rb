# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations and enums correctly' do
      expect(model).to belong_to(:organization)
      expect(model).to have_many(:expense_sheets).dependent(:restrict_with_exception)
      expect(model).to define_enum_for(:state)
    end
  end

  describe 'validations' do
    subject(:model) { described_class.new }

    it 'validates the model correctly' do
      expect(model).to validate_numericality_of(:amount).is_greater_than(0)
      expect(model).to validate_presence_of(:amount)
      expect(model).not_to validate_presence_of(:paid_timestamp)
    end

    context 'when payment is paid' do
      subject { build(:payment, :paid) }

      it { is_expected.to validate_presence_of(:paid_timestamp) }
    end

    describe 'state change validation' do
      let(:payment) { create(:payment) }

      it 'allows changing from open to paid' do
        payment.update(paid_timestamp: Time.zone.now, state: :paid)
        expect(payment).to be_valid
      end

      context 'when payment is already paid' do
        let(:payment) { create(:payment, :paid) }

        it 'does not allow changing from paid to open' do
          expect { payment.open! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe '#paid_out!' do
    let(:service) { create :service }
    let(:expense_sheets) { create_pair(:expense_sheet, service: service) }
    let(:payment) { create(:payment, expense_sheets: expense_sheets) }

    it 'updates the expense sheets state to closed when updating payment state' do
      expect { payment.paid_out! }.to(
        change { payment.expense_sheets.reload.map(&:state).uniq }.from(%w[editable]).to(%w[closed])
          .and(change { payment.reload.state }.from('open'))
          .and(change { payment.reload.paid_timestamp }.from(nil))
      )
    end

    context 'when an expense sheet is invalid' do
      before do
        # noinspection RubyNilAnalysis
        expense_sheets.first.update_column(:state, ExpenseSheet.states[:locked])
      end

      it 'does not change the expense sheets or payment' do
        expect do
          expect { payment.paid_out! }.to raise_error(ActiveRecord::RecordInvalid)
        end.not_to(change { payment.expense_sheets.reload.map(&:state).uniq })

        expect(payment.open?).to eq true
        expect(payment.paid_timestamp).to be_nil
      end
    end
  end
end
