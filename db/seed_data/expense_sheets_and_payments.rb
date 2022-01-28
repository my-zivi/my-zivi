# frozen_string_literal: true

philipp = CivilServant.find_by(email: 'philipp.zivi@example.com')
philipp_service = philipp.services.first

joel = CivilServant.find_by(email: 'joel.zivi@example.com')
joel_service = joel.services.last

andy = CivilServant.find_by(email: 'andy.zivi@example.com')
andy_service = andy.services.last

max_mustermann = CivilServant.find_by(email: 'max.zivi@example.com')
max_mustermann_services = max_mustermann.services.order(:beginning)
first_max_mustermann_service = max_mustermann_services.first

beginning = first_max_mustermann_service.beginning
ending = first_max_mustermann_service.beginning.at_end_of_month
duration = (ending.to_date - beginning.to_date).to_i

ExpenseSheetGenerator.new(max_mustermann_services.first).create_expense_sheets!

max_mustermann_services.first.expense_sheets.order(:beginning).first.update(
  beginning: beginning,
  ending: ending,
  work_days: duration - 2,
  unpaid_company_holiday_days: 0,
  paid_company_holiday_days: 0,
  company_holiday_comment: '',
  workfree_days: 1,
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
)

ExpenseSheetGenerator.new(max_mustermann_services.last).create_expense_sheets!
ExpenseSheetGenerator.new(philipp_service).create_expense_sheets!
ExpenseSheetGenerator.new(joel_service).create_expense_sheets!
ExpenseSheetGenerator.new(andy_service).create_expense_sheets!

puts '> Expense sheets seeded'

ExpenseSheet.where('ending < ?', Time.zone.now.at_end_of_month)
            .includes(service: [:organization])
            .group_by { |s| [s.beginning.month, s.service.organization.id] }
            .each do |(_month, organization_id), sheets|
  sheets.each(&:editable!)
  sheets.each { |sheet| sheet.update(amount: rand(20..70)) }

  last_ending = sheets.max_by(&:ending).ending
  payment = Payment.create!(
    organization_id: organization_id,
    expense_sheets: sheets,
    amount: sheets.sum(&:amount),
    paid_timestamp: (sheets.first.ending + 1.month).at_beginning_of_month,
    created_at: last_ending
  )

  payment.paid! if last_ending.past?
end

puts '> Payments seeded'
