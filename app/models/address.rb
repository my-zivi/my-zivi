# frozen_string_literal: true

class Address < ApplicationRecord
  has_one :organization, dependent: :restrict_with_exception
  has_one :job_posting, dependent: :nullify

  validates :city, :zip, :street, :primary_line, presence: true
  validates :latitude, :longitude, numericality: { allow_nil: true }
  validates :latitude, :longitude, presence: true, if: -> { latitude.present? || longitude.present? }
  validates :zip, numericality: { only_integer: true, greater_than_or_equal_to: 1000, less_than: 10_000 }

  def zip_with_city
    "#{zip} #{city}"
  end

  def full_compose(joiner = "\n")
    [
      primary_line,
      secondary_line,
      supplement,
      street,
      zip_with_city
    ].compact.join(joiner)
  end

  def coordinates
    coords = [latitude, longitude]

    coords if coords.all?(&:present?)
  end
end
