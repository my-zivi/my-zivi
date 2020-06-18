# frozen_string_literal: true

class ExpenseSheet < ApplicationRecord
  include DateRangeFilterable
  include ExpenseSheetStateMachine

  belongs_to :service
  belongs_to :payment, optional: true

  validates :beginning, :ending, :work_days, :state, presence: true

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

  validates :payments_id, presence: true, if: -> { state.in?(%w[payment_in_progress paid]) }
  validates :payment_timestamp, inclusion: { in: [nil] }, if: -> { state.in?(%w[open ready_for_payment]) }

  before_destroy :legitimate_destroy

  # locked - Expense sheet is not editable it's not relevant yet, e.g. in future
  # editable - Current expense sheet, relevant and editable
  # closed - Past, already paid out expense sheets, not editable
  enum state: {
    locked: 0,
    editable: 1,
    closed: 2
  }

  scope :in_payment, ->(payment_timestamp) { includes(:user).where(payment_timestamp: payment_timestamp) }
  scope :payment_issued, -> { includes(:user).where.not(payment_timestamp: [nil]) }
  scope :before_date, ->(date) { where(arel_table[:ending].lt(date)) }
  scope :filtered_by, ->(filters) { filters.reduce(self) { |query, filter| query.where(filter) } if filters.present? }

  # ExpenseSheets which can be used in calculations
  scope :relevant_for_calculations, -> { where.not(state: :locked) }

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

  alias total calculate_full_expenses

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

  def readonly?
    paid? && !state_changed? # whether or not this object can be modified anywhere
  end

  def deletable?
    open? # whether or not we can delete the expense sheet in the expense sheet view
  end

  def modifiable?
    open? # whether or not we can modify the expense sheet in the expense sheet view
  end

  private

  def fetch_service(services)
    services.including_date_range(beginning, ending).first
  end

  def eager_loaded_service(services)
    services.find { |service| service.beginning <= beginning && service.ending >= ending }
  end

  def legitimate_destroy
    return if open?

    errors.add(:base, I18n.t('expense_sheet.errors.already_paid'))
    throw :abort
  end

  def values_calculator
    @values_calculator ||= ExpenseSheetCalculators::ExpensesCalculator.new(self)
  end
end
