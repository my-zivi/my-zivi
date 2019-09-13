# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PainGenerationService, type: :service do
  describe '#generate_transaction' do
    before do
      create :service, user: user

      allow(SEPA::CreditTransfer).to receive(:new).and_return transaction_adder

      described_class.new([expense_sheet]).generate_pain
    end

    let(:transaction_adder) { instance_double(SEPA::CreditTransfer, add_transaction: true) }

    let(:user) { create :user }
    let(:expense_sheet) do
      create :expense_sheet, :ready_for_payment, user: user
    end

    context 'when there is one expense sheet' do
      let(:expected_fields) do
        {
          amount: expense_sheet.calculate_full_expenses / 100.to_f,
          batch_booking: true,
          currency: 'CHF',
          iban: user.bank_iban,
          name: user.full_name,
          remittance_information: I18n.t('payment.expenses_from',
                                         from_date: I18n.l(
                                           expense_sheet.beginning,
                                           format: '%B %Y'
                                         )),
          requested_date: Time.zone.today
        }
      end

      it 'generates transaction' do
        expect(transaction_adder).to have_received(:add_transaction)
          .with(hash_including(expected_fields))
      end
    end
  end
end
