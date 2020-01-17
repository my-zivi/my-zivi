# frozen_string_literal: true

json.extract! expense_sheet,
              :id, :bank_account_number, :beginning, :clothing_expenses,
              :clothing_expenses_comment, :company_holiday_comment, :driving_expenses, :driving_expenses_comment,
              :duration, :ending, :extraordinary_expenses, :extraordinary_expenses_comment, :paid_company_holiday_days,
              :paid_vacation_comment, :paid_vacation_days, :payment_timestamp, :sick_comment, :sick_days, :state,
              :total, :unpaid_company_holiday_days, :unpaid_vacation_comment, :unpaid_vacation_days, :user_id,
              :work_days, :workfree_days

json.deletable @expense_sheet.deletable?
json.modifiable @expense_sheet.modifiable?

# TODO: Do we really need the payment_timestamp in frontend?
