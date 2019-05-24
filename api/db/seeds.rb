# frozen_string_literal: true

require_relative 'seed_data/regional_centers'
require_relative 'seed_data/holidays'

users = User.create!(
  [
    {
      email: 'zivi@example.com',
      first_name: 'Zivi',
      last_name: 'Example',
      password: '123456',
      address: 'Zivistrasse 12a',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 18.years,
      city: 'Zivistadt',
      health_insurance: 'Militärversicherunng',
      zip: '4231',
      hometown: 'Better Zivitown',
      phone: '076 987 65 43',
      zdp: 739_539,
      regional_center: RegionalCenter.first
    },
    {
      email: 'zivi2@example.com',
      first_name: 'Zivi2',
      last_name: 'Example',
      password: '123456',
      address: 'Zivistrasse 12b',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 19.years,
      city: 'Zivistadt',
      health_insurance: 'Militärversicherunng',
      zip: '4231',
      hometown: 'Better Zivitown',
      phone: '076 876 54 32',
      zdp: 739_540,
      regional_center: RegionalCenter.first
    },
    {
      email: 'admin@example.com',
      first_name: 'Admin',
      last_name: 'Boss',
      password: '123456',
      address: 'Zivistrasse 12b',
      bank_iban: 'CH9300762011623852957',
      birthday: Time.zone.today - 19.years,
      city: 'Zivistadt',
      health_insurance: 'Militärversicherunng',
      zip: '4231',
      hometown: 'Better Zivitown',
      phone: '076 876 54 32',
      zdp: 739_540,
      regional_center: RegionalCenter.first,
      role: :admin
    }
  ]
)

at_beginning_of_month = (Time.zone.today - 1.month).at_beginning_of_month
at_end_of_month = (Time.zone.today - 1.month).at_end_of_month

def count_workdays(date)
  (1..5).cover? date.wday
end

ExpenseSheet.create!(
  user: users.first,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count(&method(:count_workdays)),
  bank_account_number: users.first.bank_iban
)

ExpenseSheet.create!(
  user: users.second,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count(&method(:count_workdays)),
  bank_account_number: users.second.bank_iban
)

service_specification = ServiceSpecification.create!(
  name: 'Gruppeneinsätze, Feldarbeiten',
  short_name: 'F',
  work_clothing_expenses: 230,
  accommodation_expenses: 0,
  work_days_expenses: { breakfast: 300, lunch: 900, dinner: 700 },
  paid_vacation_expenses: { breakfast: 300, lunch: 900, dinner: 700 },
  first_day_expenses: { breakfast: 0, lunch: 900, dinner: 700 },
  last_day_expenses: { breakfast: 300, lunch: 900, dinner: 0 },
  location: :zurich,
  active: true
)

beginning = Time.zone.today.at_beginning_of_week - 4.weeks
Service.create(
  [
    {
      user: users.first,
      service_specification: service_specification,
      beginning: beginning,
      ending: beginning + 2.weeks + 4.days,
      confirmation_date: beginning - 1.month,
      service_type: :normal,
      first_swo_service: true,
      long_service: false,
      probation_service: false,
      feedback_mail_sent: false
    },
    {
      user: users.second,
      service_specification: service_specification,
      beginning: beginning,
      ending: beginning + 3.weeks + 4.days,
      confirmation_date: beginning - 1.month,
      service_type: :normal,
      first_swo_service: true,
      long_service: false,
      probation_service: false,
      feedback_mail_sent: false
    }
  ]
)
