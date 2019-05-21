require_relative 'seed_data/regional_centers'
require_relative 'seed_data/holidays'

zivi_user = User.create!(
  email: 'zivi@example.com',
  first_name: 'Zivi',
  last_name: 'Example',
  password: '12345679',
  address: 'Zivistrasse 12a',
  bank_iban: 'CH9300762011623852957',
  birthday: Time.zone.today - 18.years,
  city: 'Zivistadt',
  health_insurance: 'Militärversicherunng',
  zip: '4231',
  hometown: 'Better Zivitown',
  phone: '076 987 65 43',
  zdp: 739539,
  regional_center: RegionalCenter.first
)

zivi_user_2 = User.create!(
  email: 'zivi2@example.com',
  first_name: 'Zivi2',
  last_name: 'Example',
  password: '12345679',
  address: 'Zivistrasse 12b',
  bank_iban: 'CH9300762011623852957',
  birthday: Time.zone.today - 19.years,
  city: 'Zivistadt',
  health_insurance: 'Militärversicherunng',
  zip: '4231',
  hometown: 'Better Zivitown',
  phone: '076 876 54 32',
  zdp: 739540,
  regional_center: RegionalCenter.first
)


at_beginning_of_month = (Time.zone.today - 1.month).at_beginning_of_month
at_end_of_month = (Time.zone.today - 1.month).at_end_of_month

ExpenseSheet.create!(
  user: zivi_user,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count {|date| (1..5).include?(date.wday) },
  bank_account_number: zivi_user.bank_iban
)

ExpenseSheet.create!(
  user: zivi_user_2,
  beginning: at_beginning_of_month,
  ending: at_end_of_month,
  work_days: (at_beginning_of_month..at_end_of_month).count {|date| (1..5).include?(date.wday) },
  bank_account_number: zivi_user_2.bank_iban
)