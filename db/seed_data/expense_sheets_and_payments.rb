# frozen_string_literal: true

philipp = User.find_by(email: 'philipp@example.com').referencee
philipp_service = philipp.services.last
max_mustermann = User.find_by(email: 'zivi@example.com').referencee
max_mustermann_services = max_mustermann.services.order(:beginning)
first_max_mustermann_service = max_mustermann_services.first

ExpenseSheet.create!(
  [
    {
      beginning: first_max_mustermann_service.beginning,
      ending: first_max_mustermann_service.beginning.at_end_of_month,
      work_days: 19,
      unpaid_company_holiday_days: 0,
      paid_company_holiday_days: 0,
      company_holiday_comment: '',
      workfree_days: 8,
      sick_days: 1,
      sick_comment: 'Phipsi had the flu',
      paid_vacation_days: 0,
      paid_vacation_comment: nil,
      unpaid_vacation_days: 0,
      unpaid_vacation_comment: nil,
      driving_expenses: 0,
      driving_expenses_comment: nil,
      extraordinary_expenses: 500,
      extraordinary_expenses_comment: 'He had to buy a Weggli',
      clothing_expenses: 0,
      clothing_expenses_comment: nil,
      state: :locked,
      credited_iban: max_mustermann.iban,
      service: first_max_mustermann_service
    }
  ]
)

ExpenseSheetGenerator.new(max_mustermann_services.last).create_expense_sheets
ExpenseSheetGenerator.new(philipp_service).create_expense_sheets

puts '> Expense sheets seeded'

ExpenseSheet.where('ending < ?', Time.zone.now)
            .includes(service: [:organization])
            .group_by { |s| [s.beginning.month, s.service.organization.id] }
            .each do |(_month, organization_id), sheets|
  sheets.each(&:editable!)
  sheets.each { |sheet| sheet.update(amount: 23) }

  Payment.create!(
    organization_id: organization_id,
    expense_sheets: sheets,
    amount: sheets.sum(&:amount),
    paid_timestamp: (sheets.first.ending + 1.month).at_beginning_of_month
  )

  sheets.map(&:reload).each(&:closed!)
end

puts '> Payments seeded'
