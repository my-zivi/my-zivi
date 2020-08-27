# frozen_string_literal: true

class Payment < ApplicationRecord
  OPEN_STATE = :open
  PAID_STATE = :paid

  belongs_to :organization
  has_many :expense_sheets, dependent: :nullify

  enum state: {
    OPEN_STATE => 0,
    PAID_STATE => 1
  }

  validates :amount, numericality: { greater_than: 0 }, presence: true
  validates :paid_timestamp, timeliness: { type: :date }, presence: true, if: :paid?
  validate :sate_change_validity

  before_destroy :prevent_destroy, if: :paid?

  def readonly?
    return false if state_changed? && state_was == OPEN_STATE.to_s

    paid?
  end

  def paid_out!
    transaction do
      expense_sheets.each { |sheet| sheet.update!(state: :closed) }
      update(state: :paid, paid_timestamp: Time.zone.now)
    end
  end

  private

  def sate_change_validity
    errors.add(:state, :invalid_state_change) if state_changed? && open? && state_was == PAID_STATE
  end

  def prevent_destroy
    throw :abort
  end
end
