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
  validates :payment_timestamp, presence: true, if: -> { state.in?(%w[payment_in_progress paid]) }
  validates :payment_timestamp, inclusion: { in: [nil] }, if: -> { state.in?(%w[open ready_for_payment]) }

  before_destroy :legitimate_destroy

  enum state: {
    open: 0,
    ready_for_payment: 1,
    payment_in_progress: 2,
    paid: 3
  }

  scope :in_payment, ->(payment_timestamp) { includes(:user).where(payment_timestamp: payment_timestamp) }

  scope :payment_issued, -> { includes(:user).where.not(payment_timestamp: [nil]) }

  scope :before_date, (->(date) { where(arel_table[:ending].lt(date)) })

  # ExpenseSheets which can be used in calculations
  scope :relevant_for_calculations, -> { where.not(state: :open) }

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

  def total_paid_vacation_days
    paid_vacation_days + paid_company_holiday_days
  end

  def total_unpaid_vacation_days
    unpaid_vacation_days + unpaid_company_holiday_days
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

  def legitimate_destroy
    return unless paid?

    errors.add(:base, I18n.t('expense_sheet.errors.already_paid'))
    throw :abort
  end

  def values_calculator
    @values_calculator ||= ExpenseSheetCalculators::ExpensesCalculator.new(self)
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
