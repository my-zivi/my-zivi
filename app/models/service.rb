# frozen_string_literal: true

class Service < ApplicationRecord

  include DateRangeFilterable
  include ServiceTimingValidations

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

  def deletable?
    sheets_in_range = civil_servant.expense_sheets.in_date_range(beginning, ending)
    sheets_in_range.nil? || sheets_in_range.count.zero?
  end

  def check_delete
    raise 'Cannot delete a service which has associated expense sheets!' unless deletable?
  end
end
