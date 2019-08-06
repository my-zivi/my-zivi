# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:beginning) { Date.parse('2018-01-01') }
  let(:ending) { Date.parse('2018-06-29') }
  let!(:service) { create :service, :long, beginning: beginning, ending: ending }
  let!(:initial_expense_sheets) do
    expense_sheets_array = ExpenseSheetGenerator.new(service).create_expense_sheets
    ExpenseSheet.where(id: expense_sheets_array.map(&:id)).all.tap do |relation|
      relation.update_all state: initial_expense_sheet_state
    end
  end
  let(:initial_expense_sheet_state) { :ready_for_payment }

  let(:initial_payment_state) do
    return { state: initial_expense_sheet_state } if initial_expense_sheet_state == :paid

    {}
  end
  let(:payment) do
    Payment.new({ expense_sheets: initial_expense_sheets }.merge(initial_payment_state))
  end
  let(:created_payment) { payment.tap(&:save) }

  describe '#initialize' do
    let(:expected_states) { [:ready_for_payment] }

    it 'creates a new payment', :aggregate_failures do
      expect(payment.payment_timestamp.present?).to eq true
      expect(payment.state).to eq :payment_in_progress
    end

    it 'doesnt update expense sheets' do
      expect(all_expense_sheet_states_of_payment(payment)).to eq expected_states
    end
  end

  describe '#save' do
    let(:all_states_lambda) { -> { all_expense_sheet_states_of_payment(payment) } }
    let(:all_payment_timestamps_lambda) { -> { all_expense_sheet_payment_timestamps_of_payment(payment) } }
    let(:expected_payment_timestamps) { [payment.payment_timestamp.to_i] }

    context 'when it is a new payment' do
      let(:expected_states) { [:payment_in_progress] }

      it 'updates expense sheets state' do
        expect { payment.save }.to change(all_states_lambda, :call).to expected_states
      end

      it 'updates expense sheets payment timestamps' do
        expect { payment.save }.to change(all_payment_timestamps_lambda, :call).to expected_payment_timestamps
      end
    end

    describe 'associated expense sheets' do
      before do
        payment.expense_sheets.each do |expense_sheet|
          allow(expense_sheet).to receive(:save)
        end

        payment.save
      end

      it 'executes #save on all expense sheets' do
        expect(payment.expense_sheets).to all have_received(:save)
      end
    end

    context 'with new payment timestamp' do
      let(:new_payment_timestamp) { 1.hour.ago }
      let(:expected_payment_timestamps) { [new_payment_timestamp.to_i] }

      before { created_payment.payment_timestamp = new_payment_timestamp }

      it 'updates expense sheets payment timestamps' do
        expect { created_payment.save }.to change(all_payment_timestamps_lambda, :call).to expected_payment_timestamps
      end
    end

    context 'with valid state transition' do
      let(:new_state) { :paid }
      let(:expected_states) { [new_state] }

      before { created_payment.state = new_state }

      it 'updates expense sheets state' do
        expect { created_payment.save }.to change(all_states_lambda, :call).to expected_states
      end

      it 'doesnt update expense sheets payment timestamp' do
        expect(all_payment_timestamps_lambda.call).to eq expected_payment_timestamps
      end
    end

    context 'with invalid state transition' do
      let(:initial_expense_sheet_state) { :paid }
      let(:new_state) { :payment_in_progress }
      let(:expected_states) { [initial_expense_sheet_state] }

      before { created_payment.state = new_state }

      it 'doesnt update expense sheets state' do
        expect(all_expense_sheet_states_of_payment(created_payment)).to eq expected_states
      end

      it 'doesnt update expense sheets payment timestamp' do
        expect(all_expense_sheet_payment_timestamps_of_payment(created_payment)).to eq expected_payment_timestamps
      end
    end
  end

  describe '#confirm' do
    let(:initial_expense_sheet_state) { :payment_in_progress }

    it 'changes state to paid' do
      expect { created_payment.confirm }.to change(created_payment, :state).to :paid
    end

    it 'doesnt change payment timestamp' do
      expect { created_payment.confirm }.not_to change(created_payment, :payment_timestamp)
    end

    it 'executes #save' do
      allow(created_payment).to receive(:save)
      created_payment.confirm
      expect(created_payment).to have_received(:save)
    end
  end

  describe '#cancel' do
    before { created_payment.cancel }

    context 'with payment in progress state' do
      let(:new_payment_timestamp) { nil }
      let(:expected_payment_timestamps) { [new_payment_timestamp.to_i] }
      let(:expected_states) { [:ready_for_payment] }

      it 'sets state to ready_for_payment' do
        expect(created_payment.state).to eq :ready_for_payment
      end

      it 'sets payment_timestamp to nil' do
        expect(created_payment.payment_timestamp).to eq nil
      end

      it 'updates expense sheets state' do
        expect(all_expense_sheet_states_of_payment(created_payment)).to eq expected_states
      end

      it 'removes expense sheets payment_timestamp' do
        expect(all_expense_sheet_payment_timestamps_of_payment(created_payment)).to eq expected_payment_timestamps
      end
    end

    context 'with paid state' do
      let(:initial_expense_sheet_state) { :paid }
      let(:expected_states) { [initial_expense_sheet_state] }
      let(:expected_payment_timestamps) { [payment.payment_timestamp.to_i] }

      it 'doesnt change expense sheets state' do
        expect(all_expense_sheet_states_of_payment(created_payment)).to eq expected_states
      end

      it 'doesnt change expense sheets payment_timestamp' do
        expect(all_expense_sheet_payment_timestamps_of_payment(created_payment)).to eq expected_payment_timestamps
      end
    end
  end

  describe '#total' do
    it 'returns the sum of full_expenses of its expense sheets' do
      expect(created_payment.total).to eq created_payment.expense_sheets.sum(&:calculate_full_expenses)
    end

    it 'executes #calculate_full_expenses on each of its expense sheets' do
      created_payment.expense_sheets.each do |expense_sheet|
        allow(expense_sheet).to receive(:calculate_full_expenses).and_return 750_000
      end
      created_payment.total
      expect(created_payment.expense_sheets).to all have_received :calculate_full_expenses
    end
  end

  describe '.find' do
    let(:payment_timestamp_to_find) { created_payment.payment_timestamp }
    let(:found_payment) { Payment.find(payment_timestamp_to_find) }

    context 'with an existing payment_timestamp' do
      it 'returns the correct payment' do
        expect(hash_of_payment(found_payment)).to eq hash_of_payment(created_payment)
      end
    end

    context 'with a non-existent payment_timestamp' do
      let(:payment_timestamp_to_find) { 1.hour.ago }
      let(:found_payment) { Payment.find(payment_timestamp_to_find) }

      it 'raises a RecordNotFound exception' do
        expect { found_payment }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end

  describe '.all' do
    let(:found_payments) { Payment.all }

    context 'with existing payments' do
      let!(:payments) do
        iota = 0
        payment_in_progress_payments = Array.new(4).map do
          iota += 1
          create_payment payment_timestamp: Time.zone.now + iota.hours
        end
        paid_payments = Array.new(2).map do
          iota += 1
          create_payment state: :paid, payment_timestamp: Time.zone.now + iota.hours
        end

        payment_in_progress_payments.push(*paid_payments)
      end

      it 'returns all corresponding payments' do
        expect(found_payments.map(&method(:hash_of_payment))).to eq payments.map(&method(:hash_of_payment))
      end
    end

    context 'with no payments' do
      it 'returns an empty array' do
        expect(found_payments).to eq []
      end
    end
  end

  describe 'validation' do
    before do
      payment.state = new_state
      payment.send(:update_expense_sheets)
    end

    context 'with an invalid state transition' do
      let(:initial_expense_sheet_state) { :paid }
      let(:new_state) { :payment_in_progress }

      it 'validates that all expense sheets are invalid' do
        expect(payment.valid?).to eq false
      end

      it 'adds all validation errors to errors' do
        expect(payment.tap(&:validate).errors.messages).to include(
          state: be_an_instance_of(Array)
        )
      end
    end

    context 'with a valid state transition' do
      let(:initial_expense_sheet_state) { :payment_in_progress }
      let(:new_state) { :paid }

      it 'validates that all expense sheets are valid' do
        expect(payment.valid?).to eq true
      end

      it 'doesnt add anything to errors' do
        expect(payment.tap(&:validate).errors.size).to eq 0
      end
    end
  end
end
