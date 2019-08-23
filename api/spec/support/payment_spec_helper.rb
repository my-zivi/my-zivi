# frozen_string_literal: true

def all_expense_sheet_states_of_payment(payment)
  payment.expense_sheets.each(&:reload).map(&:state).map(&:to_sym).uniq
end

def all_expense_sheet_payment_timestamps_of_payment(payment)
  payment.expense_sheets.each(&:reload).pluck(:payment_timestamp).uniq.map(&:to_i)
end

def hash_of_payment(payment)
  {
    state: payment.state,
    payment_timestamp: payment.payment_timestamp,
    expense_sheets: payment.expense_sheets.map(&:attributes)
  }
end

def create_payment(state: :payment_in_progress, payment_timestamp: Time.zone.now)
  previous_state = ExpenseSheet.states.key(ExpenseSheet.states[state] - 1)
  expense_sheets = create_expense_sheets(state: previous_state)

  # saving issues state update to requested state
  Payment.new(expense_sheets: expense_sheets, state: state, payment_timestamp: payment_timestamp).tap(&:save)
end

def create_expense_sheets(state:)
  service = create_service
  expense_sheets_array = ExpenseSheetGenerator.new(service).create_expense_sheets
  ExpenseSheet.where(id: expense_sheets_array.map(&:id)).all.tap do |relation|
    relation.update_all state: state
  end
end

def create_service
  beginning = Date.parse('2018-01-01')
  ending = Date.parse('2018-06-29')
  create :service, :long, beginning: beginning, ending: ending, user: create(:user)
end
