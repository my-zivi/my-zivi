# frozen_string_literal: true

class RegionalCenter < ApplicationRecord
  validates :name, :address, :short_name, presence: true
  validates :short_name, length: { is: 2 }

  has_many :users, dependent: :restrict_with_error
end
