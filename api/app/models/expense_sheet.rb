# frozen_string_literal: true

class ExpenseSheet < ApplicationRecord
  include Concerns::PositiveTimeSpanValidatable

  belongs_to :user

  validates :beginning, :ending, :user,
            :work_days, :bank_account_number, :state,
            presence: true

  validates :work_days,
            :workfree_days,
            :sick_days,
            :paid_vacation_days,
            :unpaid_vacation_days,
            :driving_expenses,
            :extraordinary_expenses,
            :clothing_expenses,
            :unpaid_company_holiday_days,
            :paid_company_holiday_days,
            numericality: { only_integer: true }

  validate :legitimate_state_change, if: :state_changed?

  enum state: {
    open: 0,
    ready_for_payment: 1,
    payment_in_progress: 2,
    paid: 3
  }

  def full_amount
    10_000 # TODO: implement correct calculator
  end

  private

  def legitimate_state_change
    return if [
      state_ready_for_payment_or_open_to_ready_for_payment_or_open?,
      state_ready_for_payment_to_payment_in_progress?,
      state_payment_in_progress_to_paid_or_ready_for_payment?
    ].one?

    errors.add(:state, :invalid_state_change)
  end

  def state_ready_for_payment_or_open_to_ready_for_payment_or_open?
    state.in?(%w[open ready_for_payment]) && state_was.in?(%w[open ready_for_payment])
  end

  def state_ready_for_payment_to_payment_in_progress?
    state.in?(%w[payment_in_progress]) && state_was.in?(%w[ready_for_payment])
  end

  def state_payment_in_progress_to_paid_or_ready_for_payment?
    state.in?(%w[paid ready_for_payment]) && state_was.in?(%w[payment_in_progress])
  end
end
