# frozen_string_literal: true

beginning_first_user_last_service = User.first.services.last.beginning
ending_first_user_last_service = User.first.services.last.ending

ExpenseSheet.create!(
  user: User.first,
  beginning: beginning_first_user_last_service,
  ending: ending_first_user_last_service,
  work_days: (beginning_first_user_last_service..ending_first_user_last_service).count(&:on_weekday?),
  workfree_days: (beginning_first_user_last_service..ending_first_user_last_service).count(&:on_weekend?),
  bank_account_number: User.first.bank_iban
)

beginning_last_user_last_service = User.find_by(email: 'zivi_francise@france.ch').services.last.beginning
ending_last_user_last_service = User.find_by(email: 'zivi_francise@france.ch').services.last.ending

ExpenseSheet.create!(
  user: User.find_by(email: 'zivi_francise@france.ch'),
  beginning: beginning_last_user_last_service,
  ending: ending_last_user_last_service,
  work_days: (beginning_last_user_last_service..ending_last_user_last_service).count(&:on_weekday?),
  workfree_days: (beginning_last_user_last_service..ending_last_user_last_service).count(&:on_weekend?),
  bank_account_number: User.find_by(email: 'zivi_francise@france.ch').bank_iban
)

# Long service ExpenseSheets

def create_last_expense_sheet(ending)
  expense_sheet_beginning = ending.beginning_of_month
  expense_sheet_ending = ending

  ExpenseSheet.create!(
    user: User.find_by(email: 'zivi_francise@france.ch'),
    beginning: expense_sheet_beginning,
    ending: expense_sheet_ending,
    work_days: (expense_sheet_beginning..expense_sheet_ending).count(&:on_weekday?),
    workfree_days: (expense_sheet_beginning..expense_sheet_ending).count(&:on_weekend?),
    bank_account_number: User.find_by(email: 'zivi_francise@france.ch').bank_iban,
    state: :open
  )
end

beginning_last_user_first_service = User.find_by(email: 'zivi_francise@france.ch').services.first.beginning
ending_last_user_first_service = User.find_by(email: 'zivi_francise@france.ch').services.first.ending

expense_sheet_beginning = beginning_last_user_first_service
expense_sheet_ending = beginning_last_user_first_service.end_of_month

while expense_sheet_ending < ending_last_user_first_service
  ExpenseSheet.create!(
    user: User.find_by(email: 'zivi_francise@france.ch'),
    beginning: expense_sheet_beginning,
    ending: expense_sheet_ending,
    work_days: (expense_sheet_beginning..expense_sheet_ending).count(&:on_weekday?),
    workfree_days: (expense_sheet_beginning..expense_sheet_ending).count(&:on_weekend?),
    bank_account_number: User.find_by(email: 'zivi_francise@france.ch').bank_iban,
    state: :open
  )

  expense_sheet_beginning = (expense_sheet_beginning + 1.month).beginning_of_month
  expense_sheet_ending = (expense_sheet_ending + 1.month).end_of_month
end

create_last_expense_sheet(ending_last_user_first_service)
