# frozen_string_literal: true

OrganizationMember.create!(
  [
    {
      organization: Organization.first,
      first_name: 'James',
      last_name: 'Bond',
      phone: '+41 (0) 76 123 45 67',
      organization_role: 'Geschäftsführung',
      user: User.new(
        email: 'admin@example.com',
        password: '12345678',
        confirmed_at: 1.year.ago
      )
    },
    {
      organization: Organization.second,
      first_name: 'Percy',
      last_name: 'Jackson',
      phone: '+41 (0) 79 123 45 68',
      organization_role: 'Leiter Zivildienst',
      user: User.new(
        email: 'admin2@example.com',
        password: '12345678',
        confirmed_at: 5.months.ago
      )
    }
  ]
)

puts '> Organizational Members seeded'
