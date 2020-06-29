# frozen_string_literal: true

class DrivingLicensesServiceSpecification < ApplicationRecord
  belongs_to :driving_license
  belongs_to :service_specification
end
