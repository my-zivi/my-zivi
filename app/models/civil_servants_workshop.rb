# frozen_string_literal: true

class CivilServantsWorkshop < ApplicationRecord
  belongs_to :civil_servant
  belongs_to :workshop
end
