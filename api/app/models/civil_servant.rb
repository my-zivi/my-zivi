# frozen_string_literal: true

class CivilServant < ApplicationRecord
  has_many :services

  belongs_to :address
  belongs_to :regional_center
  belongs_to :user

  has_many :expense_sheets, dependent: :restrict_with_error
  has_many :services, dependent: :restrict_with_error

  validates :first_name, :last_name, :address,
            :iban, :birthday, :health_insurance,
            :hometown, :phone, :zdp, presence: true
  validates :zdp, uniqueness: { case_sensitive: false }

  validates :zdp, numericality: {
    greater_than: 10_000,
    less_than: 999_999,
    only_integer: true
  }

  validates :iban, format: { with: /\ACH\d{2}(\w{4}){4,7}\w{0,2}\z/ }

  validate :validate_iban

  def self.validate_given_params(civil_servant_params)
    errors = CivilServant.new(civil_servant_params).tap(&:validate).errors

    errors.each do |attribute, _error|
      errors.delete attribute unless attribute.to_s.in?(civil_servant_params.keys.map(&:to_s))
    end

    errors
  end

  def self.strip_iban(bank_iban)
    bank_iban.gsub(/\s+/, '')
  end

  def prettified_bank_iban
    IBANTools::IBAN.new(iban).prettify
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def zip_with_city
    "#{address.zip} #{address.city}"
  end

  def jwt_payload
    { isAdmin: admin? }
  end

  def active?
    active_service.present?
  end

  def active_service
    services.find { |service| Time.zone.today.in? service.date_range }
  end

  def next_service
    services.select(&:in_future?).min_by(&:beginning)
  end

  private

  def validate_iban
    IBANTools::IBAN.new(iban).validation_errors.each do |error|
      errors.add(:iban, error)
    end
  end
end
