# frozen_string_literal: true

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
      user: User.new(
        email: 'zivi@example.com',
        password: '12345678',
        language: 'fr',
        confirmed_at: 2.years.ago
      ),
      regional_center: RegionalCenter.first,
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
      user: User.new(
        email: 'niels@example.com',
        password: '12345678',
        language: 'de',
        confirmed_at: 1.year.ago
      ),
      regional_center: RegionalCenter.first,
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
      user: User.new(
        email: 'philipp@example.com',
        password: '12345678',
        language: 'de',
        confirmed_at: 20.minutes.ago
      ),
      regional_center: RegionalCenter.second,
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
