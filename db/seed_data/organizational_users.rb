# frozen_string_literal: true

Administrator.create!(
  [
    {
      organization: Organization.first,
      user: User.new(
        email: 'admin@example.com',
        password: '12345678',
        confirmed_at: 1.year.ago
      )
    },
    {
      organization: Organization.second,
      user: User.new(
        email: 'admin2@example.com',
        password: '12345678',
        confirmed_at: 5.months.ago
      )
    }
  ]
)

puts '> Organizational Users seeded'
