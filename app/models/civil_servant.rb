# frozen_string_literal: true

require 'iban-tools'

class CivilServant < ApplicationRecord
  belongs_to :regional_center
  belongs_to :address, dependent: :destroy

  has_one :user, as: :referencee, dependent: :destroy, required: true, autosave: true

  has_many :services, dependent: :restrict_with_error
  has_many :expense_sheets, through: :services
  has_many :civil_servants_driving_licenses, dependent: :destroy
  has_many :driving_licenses, through: :civil_servants_driving_licenses
  has_many :civil_servants_workshops, dependent: :destroy
  has_many :workshops, through: :civil_servants_workshops

  validates :first_name, :last_name, :iban, :birthday, :health_insurance, :hometown, :phone, :zdp, presence: true
  validates :zdp, uniqueness: true, numericality: {
    greater_than: 10_000,
    less_than: 999_999,
    only_integer: true
  }

  validate :validate_iban
  validates :iban, format: { with: /\A\S+\z/ }

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :address

  # TODO: Move to controller probably
  def self.strip_iban(iban)
    IBANTools::IBAN.new(iban).code
  end

  def prettified_iban
    IBANTools::IBAN.new(iban).prettify
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def in_service?
    active_service.present?
  end

  def active_service
    services.find { |service| Time.zone.today.in? service.date_range }
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
end
