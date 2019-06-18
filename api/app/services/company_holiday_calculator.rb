# frozen_string_literal: true

class CompanyHolidayCalculator
  def initialize(beginning, ending)
    @range = beginning..ending
  end

  def calculate_company_holiday_days_during_service
    all_holidays = Holiday
                   .where(beginning: @range)
                   .or(Holiday.where(ending: @range))

    select_work_days(all_holidays.select(&:company_holiday?), all_holidays.select(&:public_holiday?))
      .select(&method(:day_in_range?))
      .uniq
      .length
  end

  private

  def day_in_range?(day)
    @range.cover? day
  end

  def select_work_days(company_holidays, public_holidays)
    company_holidays.flat_map { |company_holiday| company_holiday.work_days public_holidays }
  end
end
