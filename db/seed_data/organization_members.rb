# frozen_string_literal: true

alterszentrum_birkhoelzli = Organization.find_by(name: 'Alterszentrum Birkhölzli')
homoeopathy_foundation = Organization.find_by(name: 'Homöopathen Ohne Grenzen')

OrganizationMember.create!(
  [
    {
      organization: alterszentrum_birkhoelzli,
      first_name: 'Robert',
      last_name: 'Bieler',
      phone: '+41 (0) 76 123 45 67',
      organization_role: 'Geschäftsführung',
      email: 'admin@example.com',
      password: '12345678',
      language: :english,
      confirmed_at: 1.year.ago
    },
    {
      organization: alterszentrum_birkhoelzli,
      first_name: 'Emily',
      last_name: 'Clark',
      phone: '+41 (0) 70 321 54 76',
      organization_role: 'Zivildienstadministration',
      email: 'emily@example.com'
    },
    {
      organization: alterszentrum_birkhoelzli,
      first_name: 'Cobe',
      last_name: 'Black',
      phone: '+41 (0) 76 098 76 54',
      organization_role: 'Buchhaltung',
      email: 'cobe@example.com'
    },
    {
      organization: alterszentrum_birkhoelzli,
      first_name: 'Susanne',
      last_name: 'Schmid',
      phone: '+41 (0) 79 521 90 01',
      organization_role: 'Zivildienstleitung',
      email: 'susanne@example.com',
      password: '12345678',
      language: :german,
      confirmed_at: 2.years.ago
    },
    {
      organization: alterszentrum_birkhoelzli,
      first_name: 'Erwin',
      last_name: 'Schramm',
      phone: '+41 (0) 44 123 45 67',
      organization_role: 'Geschäftsleitung',
      email: 'erwin@example.com',
      password: '12345678',
      language: :german,
      confirmed_at: 2.years.ago + 1.day
    },
    {
      organization: homoeopathy_foundation,
      first_name: 'Percy',
      last_name: 'Jackson',
      phone: '+41 (0) 79 123 45 68',
      organization_role: 'Leiter Zivildienst',
      email: 'percy@example.com',
      password: '12345678',
      language: :italian,
      confirmed_at: 5.months.ago
    }
  ]
)

puts '> Organizational Members seeded'
