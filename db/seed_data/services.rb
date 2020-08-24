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
      service_specification: jugendarbeit
    },
    {
      beginning: future_service_beginning,
      ending: (future_service_beginning + 4.weeks).at_end_of_week,
      confirmation_date: 1.day.ago,
      service_type: :normal,
      last_service: true,
      feedback_mail_sent: false,
      civil_servant: max_mustermann,
      service_specification: jugendarbeit
    },
    {
      beginning: '2020-01-06',
      ending: '2020-08-28',
      confirmation_date: '2018-08-28',
      service_type: :long,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: philipp,
      service_specification: zirkusarbeit
    },
    {
      beginning: '2019-02-04',
      ending: '2019-03-08',
      confirmation_date: '2019-01-01',
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: philipp,
      service_specification: jugendarbeit
    }
  ]
)

puts '> Services seeded'
