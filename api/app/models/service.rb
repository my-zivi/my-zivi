# frozen_string_literal: true

class Service < ApplicationRecord
  FRIDAY_WEEKDAY = Date::DAYNAMES.index('Friday').freeze
  MONDAY_WEEKDAY = Date::DAYNAMES.index('Monday').freeze

  include Concerns::PositiveTimeSpanValidatable

  belongs_to :user
  belongs_to :service_specification

  enum service_type: {
    normal: 0,
    first: 1,
    last: 2
  }, _suffix: 'civil_service'

  validates :ending, :beginning, :user, :eligible_personal_vacation_days,
            :service_specification, :service_type,
            presence: true
  validates :eligible_personal_vacation_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :ending_is_friday, unless: :last_civil_service?
  validate :beginning_is_monday

  def duration
    (ending - beginning).to_i
  end

  private

  def beginning_is_monday
    errors.add(:beginning, :not_a_monday) unless beginning.present? && beginning.wday == MONDAY_WEEKDAY
  end

  def ending_is_friday
    errors.add(:ending, :not_a_friday) unless ending.present? && ending.wday == FRIDAY_WEEKDAY
  end
end
