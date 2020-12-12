# frozen_string_literal: true

require 'iban-tools'

module IbanValidatable
  def validate_iban
    IBANTools::IBAN.new(iban).validation_errors.each { |error| errors.add(:iban, error) }
  end
end
