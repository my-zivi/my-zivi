# frozen_string_literal: true

class Service < ApplicationRecord
  FRIDAY_WEEKDAY = Date::DAYNAMES.index('Friday').freeze
  MONDAY_WEEKDAY = Date::DAYNAMES.index('Monday').freeze
  LONG_MISSION_BASE_DURATION = 180
  BASE_HOLIDAY_DAYS = 8
  ADDITIONAL_HOLIDAY_DAYS_PER_MONTH = 2
  DAYS_PER_MONTH = 30

  include Concerns::PositiveTimeSpanValidatable

  belongs_to :user
  belongs_to :service_specification

  enum service_type: {
    normal: 0,
    first: 1,
    last: 2
  }, _suffix: 'civil_service'

  validates :ending, :beginning, :user,
            :service_specification, :service_type,
            presence: true

  validate :ending_is_friday, unless: :last_civil_service?
  validate :beginning_is_monday

  def duration
    (ending - beginning).to_i + 1
  end

  def eligible_personal_vacation_days
    long_service? ? calculate_eligible_personal_vacation_days : 0
  end

  def conventional_service?
    !probation_service? && !long_service?
  end

  private

  def beginning_is_monday
    errors.add(:beginning, :not_a_monday) unless beginning.present? && beginning.wday == MONDAY_WEEKDAY
  end

  def ending_is_friday
    errors.add(:ending, :not_a_friday) unless ending.present? && ending.wday == FRIDAY_WEEKDAY
  end

  def calculate_eligible_personal_vacation_days
    additional_days = duration - LONG_MISSION_BASE_DURATION
    additional_holiday_days = (additional_days / DAYS_PER_MONTH.to_f).floor * ADDITIONAL_HOLIDAY_DAYS_PER_MONTH
    BASE_HOLIDAY_DAYS + additional_holiday_days
  end
end
