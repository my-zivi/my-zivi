# frozen_string_literal: true

class SickDaysCalculator
  SICK_DAYS_PER_PERIOD = 6
  SICK_DAYS_PERIOD = 30
  DAYS_TO_SICK_DAYS = {
    (0..0) => 0,
    (1..3) => 1,
    (4..8) => 2,
    (9..14) => 3,
    (15..21) => 4,
    (22..29) => 5
  }.freeze

  class << self
    def calculate_eligible_sick_days(service_days)
      remainder = service_days % SICK_DAYS_PERIOD
      sick_days_periods = service_days / SICK_DAYS_PERIOD
      sick_days_periods * SICK_DAYS_PER_PERIOD + eligible_sick_days_remainder(remainder)
    end

    private

    def eligible_sick_days_remainder(service_days)
      DAYS_TO_SICK_DAYS.select { |range, sick_days| return sick_days if range.include? service_days }
    end
  end
end
