# frozen_string_literal: true

class CivilServantParamsModifier
  class << self
    def call(params)
      iban = params[:iban]
      params[:iban] = strip_iban(iban) if iban.present?
      params
    end

    private

    def strip_iban(iban)
      IBANTools::IBAN.new(iban).code
    end
  end
end
