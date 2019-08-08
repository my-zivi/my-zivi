# frozen_string_literal: true

class NormalServiceCalculator
  LONG_MISSION_BASE_DURATION = 180
  BASE_HOLIDAY_DAYS = 8
  ADDITIONAL_HOLIDAY_DAYS_PER_MONTH = 2
  DAYS_PER_MONTH = 30

  def initialize(beginning_date)
    @beginning_date = beginning_date
  end

  def calculate_ending_date(required_service_days)
    raise I18n.t('service_calculator.invalid_required_service_days') unless required_service_days.positive?

    temp_ending_date = @beginning_date + required_service_days.days - 1.day
    unpaid_days = calculate_unpaid_days(required_service_days, temp_ending_date)

    temp_ending_date + unpaid_days.days
  end

  def calculate_chargeable_service_days(ending_date)
    raise I18n.t('service_calculator.end_date_cannot_be_on_weekend') if ending_date.on_weekend?

    duration = (ending_date - @beginning_date).to_i + 1
    dirty_service_days = duration - calculate_unpaid_days(duration, ending_date)
    # Call calculate_unpaid_days again, in case personal_vacation_days changed
    duration - calculate_unpaid_days(dirty_service_days, ending_date)
  end

  def calculate_eligible_paid_vacation_days(service_days)
    return 0 if service_days < 180

    additional_days = service_days - LONG_MISSION_BASE_DURATION
    additional_holiday_days = ([0, additional_days].max / DAYS_PER_MONTH.to_f).floor * ADDITIONAL_HOLIDAY_DAYS_PER_MONTH
    BASE_HOLIDAY_DAYS + additional_holiday_days
  end

  private

  def calculate_unpaid_days(service_days, ending_date)
    company_holiday_days = HolidayCalculator
                           .new(@beginning_date, ending_date)
                           .calculate_company_holiday_days
    paid_vacation_days = calculate_eligible_paid_vacation_days service_days
    [0, company_holiday_days - paid_vacation_days].max
  end
end
