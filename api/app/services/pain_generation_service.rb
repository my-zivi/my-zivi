# frozen_string_literal: true

class PainGenerationService
  def initialize(sheets)
    @sheets = sheets
  end

  def generate_pain
    @sheets.each do |sheet|
      sepa_credit_transfer.add_transaction(build_transaction(sheet))
    end

    sepa_credit_transfer
  end

  private

  # :reek:FeatureEnvy
  def build_transaction(sheet)
    user = sheet.user

    {
      name: user.full_name,
      iban: user.bank_iban,
      amount: sheet.calculate_full_expenses / 100.to_f,
      currency: 'CHF',
      remittance_information: I18n.t('payment.expenses_from', from_date: I18n.l(sheet.beginning, format: '%B %Y')),
      requested_date: Time.zone.today,
      batch_booking: true,

      creditor_address: build_creditor_address(user)
    }
  end

  def build_creditor_address(user)
    SEPA::CreditorAddress.new(
      country_code: 'CH',
      street_name: user.address,
      post_code: user.zip,
      town_name: user.city
    )
  end

  def sepa_credit_transfer
    @sepa_credit_transfer ||= SEPA::CreditTransfer.new(
      name: ENV['PAIN_CREDITOR_NAME'],
      bic: ENV['PAIN_CREDITOR_BIC'],
      iban: ENV['PAIN_CREDITOR_IBAN']
    )
  end
end
