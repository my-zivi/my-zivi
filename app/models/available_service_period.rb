# frozen_string_literal: true

class AvailableServicePeriod < ApplicationRecord
  belongs_to :job_posting, inverse_of: :available_service_periods

  validates :beginning, :ending, presence: true, timeliness: { type: :date }
  validates :ending, timeliness: { on_or_after: :beginning }
end
