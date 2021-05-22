# frozen_string_literal: true

class ShortServiceCalculator
  DAYS_TO_WORKFREE_DAYS = {
    (0..6) => 0,
    (7..10) => 1,
    (11..13) => 2,
    (14..17) => 3,
    (18..20) => 4,
    (21..24) => 5,
    (25..25) => 6
  }.freeze

  def initialize(beginning_date, organization)
    @beginning_date = beginning_date
    @organization = organization
  end

  def calculate_ending_date(required_service_days)
    raise I18n.t('service_calculator.invalid_required_service_days') unless required_service_days.positive?

    EndingDateLooper.new(@beginning_date, required_service_days, @organization).ending_date
  end

  def calculate_chargeable_service_days(ending_date)
    duration = (ending_date - @beginning_date).to_i + 1

    calculator = HolidayCalculator.new(@beginning_date, ending_date, @organization)
    max_service_days = duration - calculator.calculate_company_holiday_days
    max_eligible_workfree_days = ShortServiceCalculator.eligible_workfree_days(max_service_days)

    days_to_compensate = [0, workfree_days_in_range(ending_date) - max_eligible_workfree_days].max
    compensated_service_days = max_service_days - days_to_compensate

    compensated_eligible_workfree_days = ShortServiceCalculator.eligible_workfree_days(compensated_service_days)
    compensated_service_days - (max_eligible_workfree_days - compensated_eligible_workfree_days)
  end

  def self.eligible_workfree_days(service_days)
    DAYS_TO_WORKFREE_DAYS.each do |days, workfree_days|
      return workfree_days if days.include? service_days
    end
  end

  private

  def workfree_days_in_range(ending_date)
    calculator = HolidayCalculator.new(@beginning_date, ending_date, @organization)
    public_holiday_days = calculator.calculate_public_holiday_days
    weekend_days = (@beginning_date..ending_date).count(&:on_weekend?)

    public_holiday_days + weekend_days
  end
end
