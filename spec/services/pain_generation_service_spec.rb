# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PainGenerationService, type: :service do
  describe '#generate_pain' do
    subject(:generated_pain) { described_class.execute(payment) }

    let(:organization) { service.organization }
    let(:service) { create :service }
    let(:civil_servant) { service.civil_servant }
    let(:expense_sheets) { create_pair :expense_sheet, service: service }
    let(:payment) { create :payment, expense_sheets: expense_sheets, organization: organization }

    let(:expected_transaction_values) do
      {
        amount: expense_sheets.first.calculate_full_expenses / 100.to_f,
        batch_booking: true,
        currency: 'CHF',
        iban: civil_servant.iban,
        name: civil_servant.full_name,
        remittance_information: I18n.t('payment.expenses_from',
                                       from_date: I18n.l(
                                         expense_sheets.first.beginning,
                                         format: '%B %Y'
                                       )),
        requested_date: Time.zone.today
      }
    end

    let(:expected_account_values) do
      {
        name: organization.name,
        bic: organization.creditor_detail.bic,
        iban: organization.creditor_detail.iban
      }
    end

    it 'generates transaction information correctly' do
      expected_transaction_values.each do |key, expected_value|
        expect(generated_pain.transactions.map { |transaction| transaction.public_send key }).to all eq expected_value
      end
    end

    it 'generates account information correctly' do
      expected_account_values.each do |key, expected_value|
        expect(generated_pain.account.public_send(key)).to eq expected_value
      end
    end
  end
end
