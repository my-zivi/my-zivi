# frozen_string_literal: true

class Payment < ApplicationRecord
  OPEN_STATE = :open

  belongs_to :organization
  has_many :expense_sheets, dependent: :restrict_with_exception

  enum state: {
    OPEN_STATE => 0,
    paid: 1
  }

  validates :amount, numericality: { greater_than: 0 }, presence: true
  validates :paid_timestamp, timeliness: { type: :date }, presence: true, if: :paid?

  def readonly?
    return false if state_changed? && state_was == OPEN_STATE.to_s

    paid?
  end
end
