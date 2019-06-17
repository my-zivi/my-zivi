# frozen_string_literal: true

module Concerns
  module CompanyHolidayCalculationHelper
    def calculate_company_holiday_days_during_service(beginning, ending)
      all_holidays = Holiday
                     .where(beginning: beginning..ending)
                     .or(Holiday.where(ending: beginning..ending))

      public_holidays = all_holidays.select(&:public_holiday?)
      company_holidays = all_holidays.select(&:company_holiday?)

      subtracted_days = []

      company_holidays.each do |company_holiday|
        holiday_work_days = company_holiday.work_days public_holidays
        subtracted_days.push(*holiday_work_days)
      end

      subtracted_days = subtracted_days.select { |day| (beginning..ending).cover? day }

      subtracted_days.uniq.length
    end
  end
end
