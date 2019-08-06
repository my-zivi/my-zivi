# frozen_string_literal: true

class Payment
  include ActiveModel::Model

  attr_accessor :expense_sheets, :payment_timestamp, :state

  validate :validate_expense_sheets

  def self.find(payment_timestamp)
    payment_timestamp = floor_time(payment_timestamp)
    expense_sheets = ExpenseSheet.in_payment(payment_timestamp)

    raise ActiveRecord::RecordNotFound, I18n.t('payment.errors.not_found') if expense_sheets.empty?

    state = expense_sheets.first.state
    Payment.new expense_sheets: expense_sheets, payment_timestamp: payment_timestamp, state: state
  end

  def self.all
    ExpenseSheet.payment_issued.group_by(&:payment_timestamp).map do |payment_timestamp, expense_sheets|
      state = expense_sheets.first.state
      Payment.new(expense_sheets: expense_sheets, state: state, payment_timestamp: payment_timestamp)
    end
  end

  def initialize(expense_sheets:, payment_timestamp: Time.zone.now, state: :payment_in_progress)
    raise ActiveRecord::RecordNotFound, I18n.t('payment.errors.ready_not_found') if expense_sheets.empty?

    @expense_sheets = expense_sheets
    @payment_timestamp = Payment.floor_time payment_timestamp
    @state = state.to_sym
  end

  def save
    update_expense_sheets

    return false unless valid?

    @expense_sheets.map(&:save).all?
  end

  def confirm
    @state = :paid
    save
  end

  def cancel
    state_was = @state
    payment_timestamp_was = @payment_timestamp

    @state = :ready_for_payment
    @payment_timestamp = nil

    return true if save

    @state = state_was
    @payment_timestamp = payment_timestamp_was

    update_expense_sheets

    false
  end

  def total
    @expense_sheets.sum(&:calculate_full_expenses)
  end

  def self.floor_time(time)
    time.change usec: 0
  end

  private

  def update_expense_sheets
    @expense_sheets.each do |expense_sheet|
      expense_sheet.state = @state
      expense_sheet.payment_timestamp = @payment_timestamp
    end
  end

  def validate_expense_sheets
    return if @expense_sheets.all?(&:valid?)

    expense_sheets_errors.each(&method(:add_error))
  end

  def expense_sheets_errors
    @expense_sheets.map { |expense_sheet| expense_sheet.errors.messages }.uniq
  end

  def add_error(error)
    error.each { |key, value| errors.add(key, *value) }
  end
end
