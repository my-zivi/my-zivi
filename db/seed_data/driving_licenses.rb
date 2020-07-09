# frozen_string_literal: true

DrivingLicense.create!(
  [
    { name: 'A1' },
    { name: 'A' },
    { name: 'A beschränkt' },
    { name: 'B' },
    { name: 'B1' },
    { name: 'BE' },
    { name: 'D' },
    { name: 'DE' },
    { name: 'D1' },
    { name: 'D1E' },
    { name: 'C1' },
    { name: 'C1E' },
    { name: 'CE' },
    { name: 'C' },
    { name: 'M' },
    { name: 'F' },
    { name: 'G' },
    { name: 'BPT' },
    { name: 'CZV' }
  ]
)

puts '> Driving licenses seeded'
