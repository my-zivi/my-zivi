# frozen_string_literal: true

Organization.create!(
  identification_number: '42',
  name: 'Alterszentrum Birkhölzli',
  intro_text: '24h Alterspflege',
  address: Address.new(
    primary_line: 'Alterszentrum Birkhölzli AG',
    secondary_line: nil,
    street: 'Dorfstrasse 12',
    supplement: nil,
    city: 'Schönhausen',
    zip: 8412
  ),
  creditor_detail: CreditorDetail.new(
    bic: 'ZKBKCHZZ80A',
    iban: 'CH7089144325721587778'
  ),
  subscriptions: [Subscriptions::Admin.new, Subscriptions::Recruiting.new]
)

Organization.create!(
  identification_number: '69',
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
