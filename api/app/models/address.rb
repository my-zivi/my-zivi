# frozen_string_literal: true

class Address < ApplicationRecord
  has_many :civil_servants

  validates :street, :zip, :city, presence: true
  validates :zip, numericality: { only_integer: true }
end
