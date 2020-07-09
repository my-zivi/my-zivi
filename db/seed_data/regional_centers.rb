# frozen_string_literal: true

rueti_address = Address.new(
  primary_line: 'Vollzugsstelle für den Zivildienst ZIVI',
  secondary_line: 'Regionalzentrum Rüti (ZH)',
  street: 'Spitalstrasse 31',
  supplement: 'Postfach',
  city: 'Rüti',
  zip: 8630
)

thun_address = Address.new(
  primary_line: 'Vollzugsstelle für den Zivildienst ZIVI',
  secondary_line: 'Regionalzentrum Thun',
  street: 'Malerweg 6',
  city: 'Thun',
  zip: 3600
)

RegionalCenter.create!(
  [
    {
      name: 'Regionalzentrum Rüti/ZH',
      short_name: 'Ru',
      address: rueti_address
    },
    {
      name: 'Thun',
      short_name: 'Th',
      address: thun_address
    }
  ]
)

puts '> Regional centers seeded'
