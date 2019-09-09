# frozen_string_literal: true

require 'iban-tools'

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Whitelist
  include Concerns::LegacyPasswordAuthenticatable

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
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :legacy_password, presence: true, if: -> { encrypted_password.blank? }

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

  # TODO: Remove this
  # This is a workaround in order to enable users to log in using their password they used in the old iZivi
  # Which was previously unsalted. If they logged in again, we rewrite the password using devises methods.
  # REMOVE THIS METHOD AS MOST USERS HAVE NEW PASSWORD HASHES
  # Rather let some old users reset their password than keep this method
  def valid_password?(plain_password)
    return super if legacy_password.blank?

    valid_legacy_password? plain_password
  end

  def reset_password(*args)
    reset_legacy_password
    super
  end

  private

  def validate_iban
    IBANTools::IBAN.new(bank_iban).validation_errors.each do |error|
      errors.add(:bank_iban, error)
    end
  end
end
