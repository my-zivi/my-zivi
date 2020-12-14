# frozen_string_literal: true

def create_expense_sheets(state:, service:)
  expense_sheets_array = ExpenseSheetGenerator.new(service).create_expense_sheets!
  ExpenseSheet.where(id: expense_sheets_array.map(&:id)).all.tap do |relation|
    relation.update_all state: state
  end
end
