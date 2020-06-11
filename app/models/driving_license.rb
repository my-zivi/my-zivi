# frozen_string_literal: true

class DrivingLicense < ApplicationRecord
  has_many :civil_servants_driving_licenses, dependent: :destroy
  has_many :civil_servants, through: :civil_servants_driving_licenses

  validates :name, presence: true
end
