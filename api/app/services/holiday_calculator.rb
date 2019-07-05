# frozen_string_literal: true

class HolidayCalculator
  def initialize(beginning, ending)
    @beginning = beginning
    @ending = ending
  end

  def calculate_company_holiday_days
    all_holidays = Holiday.soft_in_date_range(@beginning, @ending)
    public_holidays = all_holidays.select(&:public_holiday?)
    company_holidays = all_holidays.select(&:company_holiday?)
    all_company_holiday_work_days = select_work_days(company_holidays, public_holidays)
    total_days(all_company_holiday_work_days)
  end

  def calculate_public_holiday_days
    public_holidays = Holiday.soft_in_date_range(@beginning, @ending).select(&:public_holiday?)
    all_public_holiday_weekdays = select_work_days(public_holidays)
    total_days(all_public_holiday_weekdays)
  end

  private

  def total_days(all_days)
    all_days.select(&method(:day_in_range?)).uniq.length
  end

  def day_in_range?(day)
    (@beginning..@ending).cover? day
  end

  def select_work_days(holidays, public_holidays = nil)
    holidays.flat_map { |holiday| holiday.work_days(public_holidays) }
  end
end
