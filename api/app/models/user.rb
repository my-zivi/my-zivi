# frozen_string_literal: true

require 'iban-tools'

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Whitelist

  has_one :civil_servant

  enum role: {
    admin: 1,
    civil_servant: 2
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, :role, presence: true, unless: :only_password_changed?
  validates :email, :zdp, uniqueness: { case_sensitive: false }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: :only_password_changed?

  def self.validate_given_params(user_params)
    errors = User.new(user_params).tap(&:validate).errors

    errors.each do |attribute, _error|
      errors.delete attribute unless attribute.to_s.in?(user_params.keys.map(&:to_s))
    end

    errors
  end

  def self.strip_iban(bank_iban)
    bank_iban.gsub(/\s+/, '')
  end

  def prettified_bank_iban
    IBANTools::IBAN.new(bank_iban).prettify
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def zip_with_city
    "#{zip} #{city}"
  end

  def jwt_payload
    { isAdmin: admin? }
  end

  def reset_password(*args)
    reset_legacy_password
    super
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

  # TODO: Remove this as well
  # This is a workaround in order to enable users to change their password if they have invalid data.
  # Some users are still invalid because of the migration of the old iZivi version to the current one
  # Once all users have correct data, this should be removed and the validations should be adapted
  #
  # To see users which are still invalid, use something like this:
  # ```bash
  # echo "User.includes(:regional_center).all.reject(&:valid?)" | rails console
  # ```
  def only_password_changed?
    return false unless encrypted_password_changed?

    changes.keys.length == 1 || (legacy_password_changed? && changes.keys.length == 2)
  end

  def validate_iban
    IBANTools::IBAN.new(bank_iban).validation_errors.each do |error|
      errors.add(:bank_iban, error)
    end
  end
end
