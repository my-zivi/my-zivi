# frozen_string_literal: true

class Holiday < ApplicationRecord
  include Concerns::PositiveTimeSpanValidatable

  validates :beginning, :ending, :description, :holiday_type, presence: true

  enum holiday_type: {
    company_holiday: 1,
    public_holiday: 2
  }
end
