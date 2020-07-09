# frozen_string_literal: true

class DrivingLicensesServiceSpecification < ApplicationRecord
  belongs_to :driving_license
  belongs_to :service_specification

  validates :mandatory, presence: true

  after_initialize :build_default

  private

  def build_default
    self.mandatory ||= true
  end
end
