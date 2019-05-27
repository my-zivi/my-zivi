# frozen_string_literal: true

beginning = Time.zone.today.at_beginning_of_week - 4.weeks
Service.create!(
  [
    {
      user: User.find_by(email: 'zivi@example.com'),
      service_specification: ServiceSpecification.first,
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
      user: User.find_by(email: 'zivi_francise@france.ch'),
      service_specification: ServiceSpecification.last,
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
