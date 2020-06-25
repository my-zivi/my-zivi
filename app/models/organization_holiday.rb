# frozen_string_literal: true

class OrganizationHoliday < ApplicationRecord
  include DateRangeFilterable

  validates :beginning, :ending, :description, presence: true
  validates :beginning, :ending, timeliness: { type: :date }
  validates :ending, timeliness: { on_or_after: :beginning }

  belongs_to :organization

  # TODO: get region from organization
  def work_days(region = :ch)
    range.reject { |day| day.on_weekend? || Holidays.on(day, region).present? }
  end

  def range
    beginning..ending
  end
end
