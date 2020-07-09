# frozen_string_literal: true

max_mustermann = User.find_by(email: 'zivi@example.com').referencee
philipp = User.find_by(email: 'philipp@example.com').referencee
jugendarbeit = ServiceSpecification.find_by(name: 'Mitarbeit in der Jugendarbeit')
zirkusarbeit = ServiceSpecification.find_by(name: 'Mitarbeit Sozialpädagogische Zirkusschule')

future_service_beginning = 3.months.from_now.at_beginning_of_week

Service.create!(
  [
    {
      beginning: '2020-05-04',
      ending: '2020-06-05',
      confirmation_date: '2018-09-15',
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
    }
  ]
)

puts '> Services seeded'
