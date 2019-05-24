# frozen_string_literal: true

json.extract! expense_sheet, :id, :beginning, :ending, :work_days,
              :unpaid_company_holiday_days, :paid_company_holiday_days, :company_holiday_comment, :workfree_days,
              :sick_days, :sick_comment, :paid_vacation_days, :paid_vacation_comment, :unpaid_vacation_days,
              :unpaid_vacation_comment, :driving_expenses, :driving_expenses_comment,
              :extraordinary_expenses, :extraordinary_expenses_comment, :clothing_expenses,
              :clothing_expenses_comment, :bank_account_number, :state, :user_id
