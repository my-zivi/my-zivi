# frozen_string_literal: true

json.array! @expense_sheets do |expense_sheet|
  json.extract! expense_sheet, :id, :beginning, :ending, :duration, :state, :total
  json.user do
    json.extract! expense_sheet.user, :id, :zdp, :full_name, :bank_iban, :address, :city, :zip
  end
end
