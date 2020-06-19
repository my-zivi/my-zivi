# frozen_string_literal: true

class Service < ApplicationRecord
  FRIDAY_WEEKDAY = Date::DAYS_INTO_WEEK[:friday].freeze
  MONDAY_WEEKDAY = Date::DAYS_INTO_WEEK[:monday].freeze
  MIN_NORMAL_SERVICE_LENGTH = 26

  include DateRangeFilterable

  belongs_to :civil_servant
  belongs_to :service_specification

  has_many :expense_sheets, dependent: :restrict_with_error

  before_destroy :check_delete

  enum service_type: {
    normal: 0,
    long: 1,
    probation: 2
  }, _suffix: 'civil_service'

  validates :ending, :beginning, presence: true
  validates :ending, timeliness: { after: :beginning }

  validate :ending_is_friday, unless: :last_service?
  validate :beginning_is_monday
  validate :no_overlapping_service
  validate :length_is_valid

  scope :at_date, ->(date) { where(arel_table[:beginning].lteq(date)).where(arel_table[:ending].gteq(date)) }
  scope :chronologically, -> { order(:beginning, :ending) }
  scope :at_year, ->(year) { overlapping_date_range(Date.new(year), Date.new(year).at_end_of_year) }

  delegate :used_paid_vacation_days, :used_sick_days, to: :used_days_calculator
  delegate :remaining_paid_vacation_days, :remaining_sick_days, to: :remaining_days_calculator
  delegate :identification_number, to: :service_specification

  def service_days
    service_calculator.calculate_chargeable_service_days(ending)
  end

  def eligible_paid_vacation_days
    service_calculator.calculate_eligible_paid_vacation_days(service_days)
  end

  def eligible_sick_days
    service_calculator.calculate_eligible_sick_days(service_days)
  end

  def in_future?
    beginning.future?
  end

  def date_range
    beginning..ending
  end

  private

  def remaining_days_calculator
    @remaining_days_calculator ||= ExpenseSheetCalculators::RemainingDaysCalculator.new(self)
  end

  def used_days_calculator
    @used_days_calculator ||= ExpenseSheetCalculators::UsedDaysCalculator.new(self)
  end

  def service_calculator
    @service_calculator ||= ServiceCalculator.new(beginning, last_service?)
  end

  def no_overlapping_service
    overlaps_other_service = Service.where(civil_servant: civil_servant).where.not(id: id).overlapping_date_range(beginning, ending).any?

    errors.add(:beginning, :overlaps_service) if overlaps_other_service
  end

  def beginning_is_monday
    errors.add(:beginning, :not_a_monday) unless beginning.present? && beginning.wday == MONDAY_WEEKDAY
  end

  def ending_is_friday
    errors.add(:ending, :not_a_friday) unless ending.present? && ending.wday == FRIDAY_WEEKDAY
  end

  def length_is_valid
    return if ending.blank? || beginning.blank? || last_service?

    errors.add(:service_days, :invalid_length) if (ending - beginning).to_i + 1 < MIN_NORMAL_SERVICE_LENGTH
  end

  def deletable?
    sheets_in_range = civil_servant.expense_sheets.in_date_range(beginning, ending)
    sheets_in_range.nil? || sheets_in_range.count.zero?
  end

  def check_delete
    raise 'Cannot delete a service which has associated expense sheets!' unless deletable?
  end
end
