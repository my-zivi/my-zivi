# frozen_string_literal: true

class ShortServiceCalculator
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

  CONVERTED_LOOKUP_TABLE = [DAY_LOOKUP_TABLE.keys.flatten, DAY_LOOKUP_TABLE.values.flatten].transpose.to_h.freeze
  REVERSED_CONVERTED_LOOKUP_TABLE = CONVERTED_LOOKUP_TABLE.reverse_each.to_h.freeze

  def initialize(beginning_date)
    @beginning_date = beginning_date
  end

  def calculate_ending_date(required_service_days)
    raise I18n.t('service_calculator.invalid_required_service_days') unless required_service_days.positive?

    temp_ending_date = calculate_irregular_ending_date required_service_days
    unpaid_days = HolidayCalculator
                  .new(@beginning_date, temp_ending_date)
                  .calculate_company_holiday_days
    temp_ending_date + unpaid_days.days
  end

  def calculate_chargeable_service_days(ending_date)
    duration = (ending_date - @beginning_date).to_i + 1
    unpaid_days = HolidayCalculator
                  .new(@beginning_date, ending_date)
                  .calculate_company_holiday_days
    service_days_lookup(duration) - unpaid_days
  end

  private

  def calculate_irregular_ending_date(required_service_days)
    @beginning_date + duration_lookup(required_service_days).days - 1.day
  end

  def duration_lookup(required_service_days)
    CONVERTED_LOOKUP_TABLE[required_service_days]
  end

  def service_days_lookup(service_duration)
    REVERSED_CONVERTED_LOOKUP_TABLE.key service_duration
  end
end
