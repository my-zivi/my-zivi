# frozen_string_literal: true

require 'iban-tools'

class CivilServant < ApplicationRecord
  belongs_to :regional_center
  belongs_to :address

  has_one :user, as: :referencee, dependent: :destroy
  has_many :expense_sheets, dependent: :restrict_with_error
  has_many :services, dependent: :restrict_with_error
  has_many :civil_servants_driving_licenses, dependent: :destroy
  has_many :driving_licenses, through: :civil_servants_driving_licenses

  # TODO: Add devise
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :validatable,
  #        :jwt_authenticatable, jwt_revocation_strategy: self

  validates :first_name, :last_name, :iban, :birthday, :health_insurance, :hometown, :phone, presence: true
  validates :zdp, uniqueness: { case_sensitive: false }

  validates :bank_iban, format: { with: /\ACH\d{2}(\w{4}){4,7}\w{0,2}\z/ }

  validate :validate_iban

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
      errors.add(:bank_iban, error)
    end
  end
end
