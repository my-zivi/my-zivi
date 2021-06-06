# frozen_string_literal: true

class AvailableServicePeriod < ApplicationRecord
  belongs_to :job_posting, inverse_of: :available_service_periods

  validates :beginning, :ending, presence: true
end
