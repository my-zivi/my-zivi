# frozen_string_literal: true

module Concerns
  module CompanyHolidayCalculationHelper
    def calculate_company_holiday_days_during_service(beginning, ending)
      all_holidays = Holiday
                     .where(beginning: beginning..ending)
                     .or(Holiday.where(ending: beginning..ending))

      select_work_days(all_holidays.select(&:company_holiday?), all_holidays.select(&:public_holiday?))
        .select { |day| day_in_range?(beginning..ending, day) }
        .uniq
        .length
    end

    private

    def day_in_range?(range, day)
      range.cover? day
    end

    def select_work_days(company_holidays, public_holidays)
      company_holidays.flat_map { |company_holiday| company_holiday.work_days public_holidays }
    end
  end
end
