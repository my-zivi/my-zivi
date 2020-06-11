# frozen_string_literal: true

class Address < ApplicationRecord
  has_one :regional_center, inverse_of: :address, dependent: :restrict_with_exception
  has_one :organization, inverse_of: :address, dependent: :restrict_with_exception
  has_one :postal_organization, inverse_of: :letter_address,
                                class_name: 'Organization',
                                dependent: :restrict_with_exception

  validates :city, :zip, :street, :primary_line, presence: true
  validates :zip, numericality: { greater_than_or_equal_to: 1000, less_than: 10_000 }
end
