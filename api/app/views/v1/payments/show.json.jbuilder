# frozen_string_literal: true

json.payment_timestamp @payment.payment_timestamp.to_i
json.state @payment.state
json.total @payment.total
json.expense_sheets do
  json.array! @payment.expense_sheets do |sheet|
    json.extract! sheet, :id, :total
    json.user do
      json.extract! sheet.user, :zdp, :full_name, :id, :bank_iban
    end
  end
end
