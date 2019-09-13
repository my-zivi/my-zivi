# frozen_string_literal: true

beginning = Time.zone.today.at_beginning_of_week - 4.weeks
beginning2 = Time.zone.today.at_beginning_of_week + 1.week

Service.create!(
  [
    {
      user: User.find_by(email: 'zivi@example.com'),
      service_specification: ServiceSpecification.first,
      beginning: beginning,
      ending: beginning + 25.days,
      confirmation_date: beginning - 1.month,
      service_type: :normal,
      first_swo_service: true,
      long_service: false,
      probation_service: false,
      feedback_mail_sent: false
    },
    {
      user: User.find_by(email: 'zivi_francise@france.ch'),
      service_specification: ServiceSpecification.last,
      beginning: (Time.zone.today - 180.days).at_beginning_of_week,
      ending: Time.zone.today.at_end_of_week - 2.days,
      confirmation_date: beginning - 8.months,
      service_type: :normal,
      first_swo_service: false,
      long_service: true,
      probation_service: false,
      feedback_mail_sent: false
    },
    {
      user: User.find_by(email: 'zivi_francise@france.ch'),
      service_specification: ServiceSpecification.last,
      beginning: beginning2,
      ending: beginning2 + 3.weeks + 4.days,
      confirmation_date: beginning2 - 1.month,
      service_type: :normal,
      first_swo_service: false,
      long_service: false,
      probation_service: false,
      feedback_mail_sent: false
    }
  ]
)
