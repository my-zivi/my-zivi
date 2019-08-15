# frozen_string_literal: true

json.array! @expense_sheets do |expense_sheet|
  json.extract! expense_sheet, :id, :beginning, :ending, :duration, :state
  json.user do
    json.extract! expense_sheet.user, :id, :zdp, :full_name
  end
end
