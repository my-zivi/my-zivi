# frozen_string_literal: true

class ServiceSpecificationsWorkshop < ApplicationRecord
  belongs_to :service_specification
  belongs_to :workshop

  validates :mandatory, presence: true

  after_initialize :build_default

  private

  def build_default
    self.mandatory ||= true
  end
end
