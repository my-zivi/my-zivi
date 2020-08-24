# frozen_string_literal: true

class RegionalCenter < ApplicationRecord
  validates :name, :short_name, presence: true

  has_many :civil_servants, dependent: :restrict_with_error, inverse_of: :regional_center
  belongs_to :address, dependent: :destroy
end
