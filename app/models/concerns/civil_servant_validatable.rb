# frozen_string_literal: true

module CivilServantValidatable
  extend ActiveSupport::Concern

  included do
    validates :first_name, :last_name, presence: true

    with_options if: :personal_step_completed? do
      validates :birthday, :hometown, :phone, :zdp, presence: true
      validates :zdp, uniqueness: true, numericality: {
        greater_than: 10_000,
        less_than: 999_999,
        only_integer: true
      }, allow_nil: true
    end

    with_options if: :address_step_completed? do
      validates :address, presence: true
    end

    with_options if: :bank_and_insurance_step_completed? do
      validates :iban, :health_insurance, presence: true
      validates :iban, format: { with: /\A\S+\z/ }
      validate :validate_iban
    end

    with_options if: :service_specific_step_completed? do
      validates :regional_center, presence: true
    end
  end

  def validate_iban
    IBANTools::IBAN.new(iban).validation_errors.each do |error|
      errors.add(:iban, error)
    end
  end
end
