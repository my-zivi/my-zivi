# frozen_string_literal: true

max_mustermann = User.find_by(email: 'max.zivi@example.com').referencee
philipp = User.find_by(email: 'philipp.zivi@example.com').referencee
joel = User.find_by(email: 'joel.zivi@example.com').referencee
andy = User.find_by(email: 'andy.zivi@example.com').referencee
niels_schweizer = User.find_by(email: 'niels@example.com').referencee
jugendarbeit = ServiceSpecification.find_by(name: 'Mitarbeit in der Jugendarbeit')
zirkusarbeit = ServiceSpecification.find_by(name: 'Mitarbeit Sozialpädagogische Zirkusschule')
hausdienst = ServiceSpecification.find_by(name: 'Mitarbeit Hausdienst')

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
      civil_servant: niels_schweizer,
      service_specification: jugendarbeit,
      civil_servant_agreed: true,
      organization_agreed: true
    },
    {
      beginning: current_service_beginning - 1.week,
      ending: (current_service_beginning + 1.month + 2.weeks).at_end_of_week - 2.days,
      confirmation_date: 1.week.ago,
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: true,
      civil_servant: max_mustermann,
      service_specification: jugendarbeit,
      civil_servant_agreed: true,
      organization_agreed: true
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
      organization_agreed: true
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
      civil_servant_agreed: nil,
      organization_agreed: true
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
      organization_agreed: true
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
      organization_agreed: true
    },
    {
      beginning: '2020-08-24',
      ending: '2020-12-18',
      confirmation_date: '2020-03-12',
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: joel,
      service_specification: hausdienst,
      civil_servant_agreed: true,
      organization_agreed: true
    },
    {
      beginning: '2020-09-07',
      ending: '2020-12-18',
      confirmation_date: '2020-10-30',
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: andy,
      service_specification: hausdienst,
      civil_servant_agreed: true,
      organization_agreed: true
    },
    {
      beginning: '2020-10-26',
      ending: '2020-11-20',
      confirmation_date: nil,
      service_type: :normal,
      last_service: false,
      feedback_mail_sent: false,
      civil_servant: philipp,
      service_specification: jugendarbeit,
      civil_servant_agreed: nil,
      civil_servant_decided_at: nil,
      organization_agreed: true
    }
  ]
)

puts '> Services seeded'
