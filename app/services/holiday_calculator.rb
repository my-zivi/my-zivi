# frozen_string_literal: true

class HolidayCalculator
  def initialize(beginning, ending, region = :ch)
    @beginning = beginning
    @ending = ending
    @all_organization_holidays = OrganizationHoliday.overlapping_date_range(@beginning, @ending)
    @all_public_holidays = Holidays.between(@beginning, @ending, region)
  end

  def calculate_company_holiday_days
    all_company_holiday_work_days = @all_organization_holidays.flat_map(&:work_days)
    total_days(all_company_holiday_work_days)
  end

  def calculate_public_holiday_days
    @all_public_holidays.count { |holiday| !holiday[:date].on_weekend? }
  end

  private

  def total_days(all_days)
    all_days.select(&method(:day_in_range?)).uniq.length
  end

  def day_in_range?(day)
    (@beginning..@ending).cover? day
  end

end
