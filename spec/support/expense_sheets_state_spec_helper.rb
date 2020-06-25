# frozen_string_literal: true

def set_expense_sheet_state_to(expense_sheet, state)
  expense_sheet.state = state
  expense_sheet.save(validate: false)
end
