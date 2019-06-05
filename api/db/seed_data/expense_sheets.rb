# frozen_string_literal: true

at_beginning_of_month = (Time.zone.today - 1.month).at_beginning_of_month
at_end_of_month = (Time.zone.today - 1.month).at_end_of_month

def count_workdays(date)
  (1..5).cover? date.wday
end

ExpenseSheet.create!(
  user: User.first,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count(&method(:count_workdays)),
  bank_account_number: User.first.bank_iban
)

ExpenseSheet.create!(
  user: User.second,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count(&method(:count_workdays)),
  bank_account_number: User.second.bank_iban
)

ExpenseSheet.create!(
  user: User.second,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count(&method(:count_workdays)),
  bank_account_number: User.second.bank_iban,
  state: :ready_for_payment
)
