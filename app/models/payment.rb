# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :organization
  has_many :expense_sheets, dependent: :restrict_with_exception

  enum state: {
    open: 0,
    paid: 1
  }

  validates :paid_timestamp, timeliness: { type: :date }
  validates :amount, numericality: { greater_than: 0 }, presence: true
end
