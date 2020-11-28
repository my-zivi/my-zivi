# frozen_string_literal: true

last_registration_step = RegistrationStep.new(identifier: RegistrationStep::ALL.last)
CivilServant.create!(
  [
    {
      first_name: 'Maximilian',
      last_name: 'Mustermann',
      zdp: 345_457,
      hometown: 'Hintertupfingen',
      birthday: '2000-03-25',
      phone: '+41 (0) 76 123 45 67',
      iban: 'CH9300762011623852957',
      health_insurance: 'Sanicare',
      driving_licenses: DrivingLicense.where(name: %w[B A]),
      workshops: Workshop.where(name: %w[Kommunikation\ und\ Betreuung Pflegehilfe\ 1]),
      registration_step: last_registration_step,
      user: User.new(
        email: 'max.zivi@example.com',
        password: '12345678',
        language: 'fr',
        confirmed_at: 2.years.ago
      ),
      regional_center: RegionalCenter.rueti,
      address: Address.new(
        primary_line: 'Maximilian Mustermann',
        secondary_line: nil,
        street: 'Musterstrasse 99',
        supplement: nil,
        city: 'Beispielhausen',
        zip: 1111
      )
    },
    {
      first_name: 'Niels',
      last_name: 'Schweizer',
      zdp: 345_458,
      hometown: 'Winterthur',
      birthday: '19998-02-06',
      phone: '+41 (0) 89 123 00 12',
      iban: 'CH1589144373489824551',
      health_insurance: 'Sanicare',
      driving_licenses: DrivingLicense.where(name: %w[F]),
      workshops: [],
      registration_step: last_registration_step,
      user: User.new(
        email: 'niels@example.com',
        password: '12345678',
        language: 'de',
        confirmed_at: 1.year.ago
      ),
      regional_center: RegionalCenter.rueti,
      address: Address.new(
        primary_line: 'Niels Schweizer',
        secondary_line: nil,
        street: 'Adressenstrasse 99',
        supplement: nil,
        city: 'Zürich',
        zip: 8000
      )
    },
    {
      first_name: 'Joel',
      last_name: 'Hauser',
      zdp: 401_413,
      hometown: 'Zürich',
      birthday: '1998-04-10',
      phone: '+41 (0) 79 893 67 22',
      iban: 'CH2089144524178462422',
      health_insurance: 'Sanicare',
      driving_licenses: DrivingLicense.where(name: %w[B C1]),
      workshops: Workshop.where(name: 'Alp-Pflege'),
      registration_step: last_registration_step,
      user: User.new(
        email: 'joel.zivi@example.com',
        password: '12345678',
        language: 'de',
        confirmed_at: 1.year.ago
      ),
      regional_center: RegionalCenter.rueti,
      address: Address.new(
        primary_line: 'Joel Hauser',
        secondary_line: nil,
        street: 'Dorfstrasse 12b',
        supplement: nil,
        city: 'Embrach',
        zip: 8424
      )
    },
    {
      first_name: 'Andy',
      last_name: 'Pfeuti',
      zdp: 401_414,
      hometown: 'Bellinzona',
      birthday: '1997-07-10',
      phone: '+41 (0) 76 831 12 21',
      iban: 'CH0289144539255522334',
      health_insurance: 'Helsana',
      driving_licenses: DrivingLicense.where(name: []),
      workshops: [Workshop.find_by(name: 'Umwelt- und Naturschutz')],
      registration_step: last_registration_step,
      user: User.new(
        email: 'andy.zivi@example.com',
        password: '12345678',
        language: 'de',
        confirmed_at: 5.months.ago
      ),
      regional_center: RegionalCenter.thun,
      address: Address.new(
        primary_line: 'Andy Pfeuti',
        secondary_line: nil,
        street: 'Rosenstrasse 14',
        supplement: nil,
        city: 'Schlieren',
        zip: 8952
      )
    },
    {
      first_name: 'Philipp',
      last_name: 'Van Fehr',
      zdp: 117_885,
      hometown: 'Winterthur',
      birthday: '1998-04-27',
      phone: '+41 (0) 79 123 45 67',
      iban: 'CH7789144252251383895',
      driving_licenses: [],
      workshops: [Workshop.find_by(name: 'Umwelt- und Naturschutz')],
      health_insurance: 'Zivicare P1us',
      registration_step: last_registration_step,
      user: User.new(
        email: 'philipp.zivi@example.com',
        password: '12345678',
        language: 'de',
        confirmed_at: 20.minutes.ago
      ),
      regional_center: RegionalCenter.thun,
      address: Address.new(
        primary_line: 'Philipp Van Fehr',
        secondary_line: nil,
        street: 'Thalwiesenstrasse 12',
        supplement: nil,
        city: 'Winterthur',
        zip: 8400
      )
    }
  ]
)

puts '> Civil servants seeded'
