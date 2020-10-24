# frozen_string_literal: true

require 'iban-tools'
require 'regional_center_column'
require 'registration_step_column'

class CivilServant < ApplicationRecord
  attribute :regional_center, RegionalCenterColumn.new
  attribute :registration_step, RegistrationStepColumn.new

  belongs_to :address, dependent: :destroy, optional: true

  has_one :user, as: :referencee, dependent: :destroy, required: true, autosave: true

  has_many :services, dependent: :restrict_with_error
  has_many :expense_sheets, through: :services
  has_many :civil_servants_driving_licenses, dependent: :destroy
  has_many :driving_licenses, through: :civil_servants_driving_licenses
  has_many :civil_servants_workshops, dependent: :destroy
  has_many :workshops, through: :civil_servants_workshops

  validates :first_name, :last_name, presence: true

  with_options if: :registration_complete? do
    validates :address, :iban, :birthday, :health_insurance, :hometown, :phone, :zdp, presence: true
    validates :iban, format: { with: /\A\S+\z/ }
    validate :validate_iban
    validates :zdp, uniqueness: true, numericality: {
      greater_than: 10_000,
      less_than: 999_999,
      only_integer: true
    }
  end

  delegate :complete?, to: :registration_step, prefix: 'registration', allow_nil: true

  accepts_nested_attributes_for :user, allow_destroy: false
  accepts_nested_attributes_for :address, allow_destroy: false, update_only: true

  after_commit :update_address, on: :update

  def prettified_iban
    IBANTools::IBAN.new(iban).prettify
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def in_service?
    active_service.present?
  end

  # :reek:FeatureEnvy
  def active_service(organization = nil)
    services.find do |service|
      in_organization = (organization.nil? || service.service_specification.organization_id == organization.id)

      in_organization && Time.zone.today.in?(service.date_range)
    end
  end

  def next_service
    services.select(&:future?).min_by(&:beginning)
  end

  private

  def validate_iban
    IBANTools::IBAN.new(iban).validation_errors.each do |error|
      errors.add(:iban, error)
    end
  end

  def update_address
    address.update!(primary_line: full_name)
  rescue ActiveRecord::RecordInvalid => e
    Raven.capture_exception(e, extra: address.errors) if defined? Raven
  end
end
