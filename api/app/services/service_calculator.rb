# frozen_string_literal: true

class ServiceCalculator
  SATURDAY_WEEKDAY = Date::DAYNAMES.index('Saturday').freeze
  SUNDAY_WEEKDAY = Date::DAYNAMES.index('Sunday').freeze

  # rubocop:disable Layout/AlignHash
  DAY_LOOKUP_TABLE = {
    (1..5).to_a   => (1..5).to_a,
    [6, 7]        => [8, 8],
    (8..10).to_a  => (9..11).to_a,
    (11..12).to_a => (11..12).to_a,
    [13]          => [15],
    (14..17).to_a => (15..18).to_a,
    [18, 19]      => [18, 19],
    [20]          => [22],
    (21..24).to_a => (22..25).to_a,
    [25]          => [25]
  }.freeze
  # rubocop:enable Layout/AlignHash

  LINEAR_CALCULATION_THRESHOLD = 26
  CONVERTED_LOOKUP_TABLE = [DAY_LOOKUP_TABLE.keys.flatten, DAY_LOOKUP_TABLE.values.flatten].transpose.to_h.freeze
  REVERSED_CONVERTED_LOOKUP_TABLE = CONVERTED_LOOKUP_TABLE.reverse_each.to_h.freeze

  def initialize(beginning_date)
    @beginning_date = beginning_date
  end

  def calculate_ending_date(required_service_days)
    raise I18n.t('service_calculator.invalid_required_service_days') unless required_service_days.positive?

    return calculate_linear_ending_date(required_service_days) if required_service_days >= LINEAR_CALCULATION_THRESHOLD

    calculate_irregular_ending_date(required_service_days)
  end

  def calculate_chargeable_service_days(ending_date)
    raise I18n.t('service_calculator.end_date_cannot_be_on_weekend') if ending_date.on_weekend?

    duration = (ending_date - @beginning_date).to_i + 1
    return duration if duration >= LINEAR_CALCULATION_THRESHOLD

    reverse_duration_lookup(duration)
  end

  private

  def calculate_irregular_ending_date(required_service_days)
    @beginning_date + duration_lookup(required_service_days).days - 1.day
  end

  def duration_lookup(required_service_days)
    CONVERTED_LOOKUP_TABLE[required_service_days]
  end

  def reverse_duration_lookup(service_duration)
    REVERSED_CONVERTED_LOOKUP_TABLE.key service_duration
  end

  def calculate_linear_ending_date(required_service_days)
    ending = @beginning_date + required_service_days.days - 1.day
    return ending unless ending.on_weekend?

    (ending + 1.week).at_beginning_of_week
  end
end
