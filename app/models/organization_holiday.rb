# frozen_string_literal: true

class OrganizationHoliday < ApplicationRecord
  include DateRangeFilterable

  validates :beginning, :ending, timeliness: { type: :date }
  validates :beginning, :ending, :description, presence: true
  validates :beginning, timeliness: { after: :ending }

  belongs_to :organization

  # TODO: Implement with holidays gem
  def work_days(public_holidays = nil)
    range.reject { |day| day.on_weekend? || day_on_public_holiday?(day, public_holidays) }
  end

  def range
    beginning..ending
  end

  private

  # :reek:UtilityFunction
  def day_on_public_holiday?(day, public_holidays)
    public_holidays.any? { |public_holiday| public_holiday.range.include? day }
  end
end
