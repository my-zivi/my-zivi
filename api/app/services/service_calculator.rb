# frozen_string_literal: true

class ServiceCalculator
  LINEAR_CALCULATION_THRESHOLD = 26
  SERVICE_DAYS_PER_SICK_DAY = 5

  def initialize(beginning_date)
    @beginning_date = beginning_date
  end

  def calculate_ending_date(required_service_days)
    unless required_service_days.positive?
      raise CalculationError, I18n.t('service_calculator.invalid_required_service_days')
    end

    if required_service_days < LINEAR_CALCULATION_THRESHOLD
      short_service_calculator.calculate_ending_date required_service_days
    else
      normal_service_calculator.calculate_ending_date required_service_days
    end
  end

  def calculate_chargeable_service_days(ending_date)
    raise CalculationError, I18n.t('service_calculator.end_date_cannot_be_on_weekend') if ending_date.on_weekend?

    duration = (ending_date - @beginning_date).to_i + 1

    if duration < LINEAR_CALCULATION_THRESHOLD
      short_service_calculator.calculate_chargeable_service_days ending_date
    else
      normal_service_calculator.calculate_chargeable_service_days ending_date
    end
  end

  def calculate_eligible_paid_vacation_days(service_days)
    return 0 if service_days < 180

    normal_service_calculator.calculate_eligible_paid_vacation_days service_days
  end

  def calculate_eligible_sick_days(service_days)
    service_days / SERVICE_DAYS_PER_SICK_DAY
  end

  private

  def short_service_calculator
    @short_service_calculator ||= ShortServiceCalculator.new @beginning_date
  end

  def normal_service_calculator
    @normal_service_calculator ||= NormalServiceCalculator.new @beginning_date
  end
end
