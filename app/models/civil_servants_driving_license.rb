# frozen_string_literal: true

class CivilServantsDrivingLicense < ApplicationRecord
  belongs_to :driving_license
  belongs_to :civil_servant
end
