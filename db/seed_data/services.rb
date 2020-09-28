# frozen_string_literal: true

max_mustermann = User.find_by(email: 'zivi@example.com').referencee
philipp = User.find_by(email: 'philipp@example.com').referencee
jugendarbeit = ServiceSpecification.find_by(name: 'Mitarbeit in der Jugendarbeit')
zirkusarbeit = ServiceSpecification.find_by(name: 'Mitarbeit Sozialpädagogische Zirkusschule')

future_service_beginning = 3.months.from_now.at_beginning_of_week

current_service_beginning = 1.month.ago.at_beginning_of_week

Service.create!(
  [
    {
      beginning: current_service_beginning,
      ending: (current_service_beginning + 1.month + 1.week).at_end_of_week - 2.days,
      confirmation_date: 6.days.ago,
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: true,
      civil_servant: max_mustermann,
      service_specification: jugendarbeit,
      civil_servant_agreed: true,
      civil_servant_agreed_on: 3.weeks.ago,
      organization_agreed: true,
      organization_agreed_on: 3.weeks.ago
    },
    {
      beginning: future_service_beginning,
      ending: (future_service_beginning + 4.weeks).at_end_of_week - 2.days,
      confirmation_date: 1.day.ago,
      service_type: :normal,
      last_service: true,
      feedback_mail_sent: false,
      civil_servant: max_mustermann,
      service_specification: zirkusarbeit,
      civil_servant_agreed: true,
      civil_servant_agreed_on: 1.week.ago,
      organization_agreed: true,
      organization_agreed_on: 1.week.ago
    },
    {
      beginning: future_service_beginning,
      ending: (future_service_beginning + 4.weeks).at_end_of_week - 2.days,
      confirmation_date: nil,
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: philipp,
      service_specification: zirkusarbeit,
      civil_servant_agreed: false,
      civil_servant_agreed_on: nil,
      organization_agreed: true,
      organization_agreed_on: 1.week.ago
    },
    {
      beginning: '2020-01-06',
      ending: '2020-08-28',
      confirmation_date: '2018-08-28',
      service_type: :long,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: philipp,
      service_specification: zirkusarbeit,
      civil_servant_agreed: true,
      civil_servant_agreed_on: '2018-07-20',
      organization_agreed: true,
      organization_agreed_on: '2018-07-20'
    },
    {
      beginning: '2019-02-04',
      ending: '2019-03-08',
      confirmation_date: '2019-01-01',
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: philipp,
      service_specification: jugendarbeit,
      civil_servant_agreed: true,
      civil_servant_agreed_on: '2018-12-20',
      organization_agreed: true,
      organization_agreed_on: '2018-12-20'
    }
  ]
)

puts '> Services seeded'
