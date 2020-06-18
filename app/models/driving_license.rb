# frozen_string_literal: true

class DrivingLicense < ApplicationRecord
  has_many :civil_servants_driving_licenses, dependent: :destroy
  has_many :civil_servants, through: :civil_servants_driving_licenses
  has_many :driving_licenses_service_specifications, dependent: :destroy
  has_many :service_specifications, through: :driving_licenses_service_specifications

  validates :name, presence: true
end
