# frozen_string_literal: true

zuckerberg_foundation = Organization.find_by(name: 'Zuckerberg Foundation')

OrganizationHoliday.create!(
  organization: zuckerberg_foundation,
  beginning: Date.parse('2020-01-06'),
  ending: Date.parse('2020-01-12'),
  description: 'Zuckerberg international peace week'
)

puts '> Organization holidays seeded'
