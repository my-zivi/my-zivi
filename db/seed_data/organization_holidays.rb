# frozen_string_literal: true

alterszentrum_birkhoelzli = Organization.find_by(name: 'Alterszentrum Birkhölzli')

OrganizationHoliday.create!(
  organization: alterszentrum_birkhoelzli,
  beginning: Date.parse('2020-01-06'),
  ending: Date.parse('2020-01-12'),
  description: 'Zuckerberg international peace week'
)

puts '> Organization holidays seeded'
