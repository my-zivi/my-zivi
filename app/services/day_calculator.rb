# frozen_string_literal: true

class DayCalculator
  delegate :calculate_public_holiday_days,
           :calculate_company_holiday_days,
           to: :holiday_calculator

  def initialize(beginning, ending, organization)
    @beginning = beginning
    @ending = ending
    @organization = organization
  end

  def calculate_workfree_days
    workfree_days = (@beginning..@ending).count(&:on_weekend?)
    workfree_days + holiday_calculator.calculate_public_holiday_days
  end

  def calculate_work_days
    total = (@beginning..@ending).count
    unpaid_days = holiday_calculator.calculate_company_holiday_days
    total - calculate_workfree_days - unpaid_days
  end

  private

  def holiday_calculator
    @holiday_calculator ||= HolidayCalculator.new(@beginning, @ending, @organization)
  end
end
