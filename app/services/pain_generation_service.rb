# frozen_string_literal: true

class PainGenerationService
  class << self
    def execute(payment)
      sepa_credit_transfer = build_credit_transfer(payment.organization)

      payment.expense_sheets.each do |sheet|
        sepa_credit_transfer.add_transaction(build_transaction(sheet))
      end

      sepa_credit_transfer
    end

    private

    def build_credit_transfer(organization)
      SEPA::CreditTransfer.new(
        name: organization.name,
        bic: organization.creditor_detail.bic,
        iban: organization.creditor_detail.iban
      )
    end

    def build_transaction(sheet)
      civil_servant = sheet.service.civil_servant

      {
        name: civil_servant.full_name,
        iban: civil_servant.iban,
        amount: sheet.calculate_full_expenses / 100.to_f,
        currency: 'CHF',
        remittance_information: I18n.t('payment.expenses_from', from_date: I18n.l(sheet.beginning, format: '%B %Y')),
        requested_date: Time.zone.today,
        batch_booking: true,

        creditor_address: build_creditor_address(civil_servant.address)
      }
    end

    def build_creditor_address(address)
      SEPA::CreditorAddress.new(
        country_code: 'CH',
        street_name: address.street,
        post_code: address.zip,
        town_name: address.city
      )
    end
  end
end
