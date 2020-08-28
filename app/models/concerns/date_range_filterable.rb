# frozen_string_literal: true

module DateRangeFilterable
  extend ActiveSupport::Concern

  included do
    # All instances whose beginning and ending range is fully or partially covering the passed date range
    scope :overlapping_date_range, lambda { |beginning, ending|
      where(arel_table[:beginning].lteq(ending))
        .where(arel_table[:ending].gteq(beginning))
    }

    scope :covering_date, lambda { |date = Time.zone.now|
      where(arel_table[:beginning].lteq(date))
        .where(arel_table[:ending].gteq(date))
    }
  end
end
