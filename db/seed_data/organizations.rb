# frozen_string_literal: true

Organization.create!(
  name: 'Zuckerberg Foundation',
  intro_text: 'We love sugar',
  address: Address.new(
    primary_line: 'Zuckerberg Foundation AG',
    secondary_line: nil,
    street: 'Dorfstrasse 12',
    supplement: nil,
    city: 'Glattfelden',
    zip: 8192
  ),
  creditor_detail: CreditorDetail.new(
    bic: 'ZKBKCHZZ80A',
    iban: 'CH7089144325721587778'
  )
)

Organization.create!(
  name: 'Homöopathen Ohne Grenzen',
  intro_text: 'Wir heilen alles, selbst das Unheilbare',
  address: Address.new(
    primary_line: 'Homöopathen Ohne Grenzen GmbH',
    secondary_line: nil,
    street: 'Planetenstrasse 72a',
    supplement: nil,
    city: 'Winterthur',
    zip: 8303
  ),
  creditor_detail: CreditorDetail.new(
    bic: 'ZKBKCHZZ80A',
    iban: 'CH6489144587488177869'
  )
)

puts '> Organizations seeded'
