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

  enum state: {
    open: 0,
    ready_for_payment: 1,
    payment_in_progress: 2,
    paid: 3
  }
end
