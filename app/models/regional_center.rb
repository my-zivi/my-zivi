# frozen_string_literal: true

class RegionalCenter < ApplicationRecord
  validates :name, :short_name, presence: true
  validates :short_name, length: { is: 2 }

  has_many :civil_servants, dependent: :restrict_with_error, inverse_of: :regional_center
  belongs_to :address, dependent: :destroy
end
