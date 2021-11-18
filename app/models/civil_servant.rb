# frozen_string_literal: true

require 'iban-tools'
require 'regional_center_column'
require 'registration_step_column'

class CivilServant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  include LoginableUser
  include CivilServantValidatable
  extend CivilServantSearchable

  attribute :regional_center, RegionalCenterColumn.new
  attribute :registration_step, RegistrationStepColumn.new

  belongs_to :address, dependent: :destroy, optional: true

  has_many :services, dependent: :restrict_with_error
  has_many :expense_sheets, through: :services
  has_many :civil_servants_driving_licenses, dependent: :destroy
  has_many :driving_licenses, through: :civil_servants_driving_licenses
  has_many :civil_servants_workshops, dependent: :destroy
  has_many :workshops, through: :civil_servants_workshops

  delegate :complete?, to: :registration_step, prefix: 'registration', allow_nil: true
  delegate :personal_step_completed?,
           :address_step_completed?,
           :bank_and_insurance_step_completed?,
           :service_specific_step_completed?,
           to: :registration_step, allow_nil: true
  alias registered? service_specific_step_completed?

  accepts_nested_attributes_for :address, allow_destroy: false, update_only: true

  after_commit :update_address, on: :update, if: -> { address.present? }

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

  def update_address
    address.update!(primary_line: full_name)
  rescue ActiveRecord::RecordInvalid => e
    Sentry.capture_exception(e, extra: address.errors) if defined? Sentry
  end
end
