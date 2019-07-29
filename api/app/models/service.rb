# frozen_string_literal: true

class Service < ApplicationRecord
  FRIDAY_WEEKDAY = Date::DAYNAMES.index('Friday').freeze
  MONDAY_WEEKDAY = Date::DAYNAMES.index('Monday').freeze

  include Concerns::PositiveTimeSpanValidatable
  include Concerns::DateRangeFilterable

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

  scope :at_date, ->(date) { where(arel_table[:beginning].lteq(date)).where(arel_table[:ending].gteq(date)) }
  scope :chronologically, -> { order(:beginning, :ending) }
  # TODO: Check if this is correct (my opinion: should be touching_date_range, because Services with a beginning in
  # last year and ending in current_year should be included in at_year(current_year) too)
  scope :at_year, ->(year) { in_date_range(Date.new(year), Date.new(year).at_end_of_year) }

  delegate :identification_number, to: :service_specification

  def service_days
    ServiceCalculator.new(beginning).calculate_chargeable_service_days(ending)
  end

  def eligible_personal_vacation_days
    ServiceCalculator.new(beginning).calculate_eligible_personal_vacation_days(service_days)
  end

  def conventional_service?
    !probation_service? && !long_service?
  end

  def expense_sheets
    @expense_sheets ||= user.expense_sheets.in_date_range(beginning, ending)
  end

  private

  def beginning_is_monday
    errors.add(:beginning, :not_a_monday) unless beginning.present? && beginning.wday == MONDAY_WEEKDAY
  end

  def ending_is_friday
    errors.add(:ending, :not_a_friday) unless ending.present? && ending.wday == FRIDAY_WEEKDAY
  end
end
