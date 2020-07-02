# frozen_string_literal: true

module DateRangeFilterable
  extend ActiveSupport::Concern

  included do
    # All instances whose beginning and ending range is fully or partially covering the passed date range
    scope :overlapping_date_range, (lambda do |beginning, ending|
      where(arel_table[:beginning].lteq(ending))
        .where(arel_table[:ending].gteq(beginning))
    end)
  end
end
