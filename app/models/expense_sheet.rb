# frozen_string_literal: true

class ExpenseSheet < ApplicationRecord
  include DateRangeFilterable
  include ExpenseSheetStateMachine

  belongs_to :service
  belongs_to :payment, optional: true

  has_one :service_specification, through: :service

  validates :beginning, :ending, :work_days, :state, :service, presence: true

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

  validates :payment_id, presence: true, if: :closed?
  validates :ending, timeliness: { on_or_after: :beginning }
  validate :included_in_service_date_range

  before_destroy :legitimate_destroy

  # locked - Expense sheet is not editable it's not relevant yet, e.g. in future
  # editable - Current expense sheet, relevant and editable
  # closed - Past, already paid out expense sheets, not editable
  enum state: {
    locked: 0,
    editable: 1,
    closed: 2
  }

  scope :in_payment, ->(payment_timestamp) { includes(:civil_servant).where(payment_timestamp: payment_timestamp) }
  scope :payment_issued, -> { includes(:civil_servant).where.not(payment_timestamp: [nil]) }
  scope :before_date, ->(date) { where(arel_table[:ending].lt(date)) }

  # ExpenseSheets which can be used in calculations
  scope :relevant_for_calculations, -> { where(state: :closed) }

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
    closed? && !state_changed?
  end

  private

  def included_in_service_date_range
    return if service.nil?
    return if beginning >= service.beginning && ending <= service.ending

    errors.add(:base, I18n.t('activerecord.errors.models.expense_sheet.outside_service_date_range'))
  end

  # TODO: Remove, left from legacy. Just here for the sake of documentation
  # def fetch_service(services)
  #   services.including_date_range(beginning, ending).first
  # end

  # TODO: Remove, left from legacy. Just here for the sake of documentation
  # def eager_loaded_service(services)
  #   services.find { |service| service.beginning <= beginning && service.ending >= ending }
  # end

  def legitimate_destroy
    return unless closed?

    errors.add(:base, I18n.t('activerecord.errors.models.expense_sheet.already_paid'))
    throw :abort
  end

  def values_calculator
    @values_calculator ||= ExpenseSheetCalculators::ExpensesCalculator.new(self)
  end
end
