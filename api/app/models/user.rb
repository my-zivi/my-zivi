# frozen_string_literal: true

require 'iban-tools'

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Whitelist

  belongs_to :regional_center

  has_many :expense_sheets, dependent: :restrict_with_error
  has_many :services, dependent: :restrict_with_error

  enum role: {
    admin: 1,
    civil_servant: 2
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :first_name, :last_name, :email,
            :address, :bank_iban, :birthday,
            :city, :health_insurance, :role,
            :zip, :hometown, :phone, presence: true

  validates :zdp, numericality: { greater_than: 25_000, less_than: 999_999, only_integer: true }
  validates :zip, numericality: { only_integer: true }
  validates :bank_iban, format: { with: /\ACH\d{2}(\w{4}){4,7}\w{0,2}\z/ }

  validate :validate_iban

  def full_name
    "#{first_name} #{last_name}"
  end

  def zip_with_city
    "#{zip} #{city}"
  end

  def jwt_payload
    { isAdmin: admin? }
  end

  def active?
    services.at_date(Time.zone.today).any?
  end

  def self.validate_given_params(user_params)
    errors = User.new(user_params).tap(&:validate).errors

    errors.each do |attribute, _error|
      errors.delete attribute unless attribute.to_s.in?(user_params.keys.map(&:to_s))
    end

    errors
  end

  private

  def validate_iban
    IBANTools::IBAN.new(bank_iban).validation_errors.each do |error|
      errors.add(:bank_iban, error)
    end
  end
end
