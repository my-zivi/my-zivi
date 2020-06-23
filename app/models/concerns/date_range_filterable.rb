# frozen_string_literal: true

module DateRangeFilterable
  extend ActiveSupport::Concern

  included do
    # All instances whose beginning and ending range is completely inside the passed date range
    scope :in_date_range, (lambda do |beginning, ending|
      where(arel_table[:beginning].gteq(beginning))
        .where(arel_table[:ending].lteq(ending))
    end)

    # All instances whose beginning and ending range completely contains the passed date range
    scope :including_date_range, (lambda do |beginning, ending|
      where(arel_table[:beginning].lteq(beginning))
        .where(arel_table[:ending].gteq(ending))
    end)

    # All instances whose beginning and ending range is fully or partially covering the passed date range
    scope :overlapping_date_range, (lambda do |beginning, ending|
      where(arel_table[:beginning].lteq(ending))
        .where(arel_table[:ending].gteq(beginning))
    end)
  end
end
