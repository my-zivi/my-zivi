# frozen_string_literal: true

class ServiceSpecificationsWorkshop < ApplicationRecord
  validates :mandatory, presence: true
end
