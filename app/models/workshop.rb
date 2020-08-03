# frozen_string_literal: true

class Workshop < ApplicationRecord
  has_many :service_specifications_workshops, dependent: :restrict_with_exception
  has_many :service_specifications, through: :service_specifications_workshops

  has_many :civil_servants_workshops, dependent: :restrict_with_exception
  has_many :civil_servants, through: :civil_servants_workshops

  validates :name, presence: true
end
