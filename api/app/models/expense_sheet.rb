# frozen_string_literal: true

class ExpenseSheet < ApplicationRecord
  include Concerns::PositiveTimeSpanValidatable
  include Concerns::DateRangeFilterable

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

  scope :before_date, (->(date) { where(arel_table[:ending].lt(date)) })

  delegate :calculate_chargeable_days,
           :calculate_first_day,
           :calculate_full_expenses,
           :calculate_last_day,
           :calculate_paid_vacation_days,
           :calculate_sick_days,
           :calculate_unpaid_vacation_days,
           :calculate_work_clothing_expenses,
           :calculate_work_days,
           :calculate_workfree_days,
           to: :values_calculator

  def service
    @service ||= user.services.including_date_range(beginning, ending).first
  end

  def duration
    (ending - beginning).to_i + 1
  end

  def work_days_count
    work_days - [at_service_beginning?, at_service_ending?].count(&:itself)
  end

  def at_service_beginning?
    beginning == service.beginning
  end

  def at_service_ending?
    ending == service.ending
  end

  private

  def values_calculator
    @values_calculator ||= ExpenseSheetCalculatorService.new(self)
  end

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
