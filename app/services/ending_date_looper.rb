# frozen_string_literal: true

class EndingDateLooper
  def initialize(beginning, service_days)
    @beginning = beginning
    @service_days = service_days
    @remaining_workfree_days = ShortServiceCalculator.eligible_workfree_days(service_days)
  end

  def ending_date
    # Subtracting 1 day because the loop checks the following day
    check_date = @beginning - 1.day
    leftover_service_days = @service_days

    until leftover_service_days.zero?
      check_date += 1.day

      leftover_service_days -= 1 if chargeable_day?(check_date)
    end

    check_date
  end

  private

  def chargeable_day?(day)
    return false if company_holiday_day?(day)

    if workfree_day?(day)
      return false if @remaining_workfree_days.zero?

      @remaining_workfree_days -= 1
    end

    true
  end

  def company_holiday_day?(day)
    HolidayCalculator.new(day, day).calculate_company_holiday_days.positive?
  end

  def workfree_day?(day)
    [
      HolidayCalculator.new(day, day).calculate_public_holiday_days.positive?,
      day.on_weekend?
    ].any?
  end
end
