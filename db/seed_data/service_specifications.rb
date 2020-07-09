# frozen_string_literal: true

zuckerberg_foundation = Organization.find_by(name: 'Zuckerberg Foundation')
homoeopathy_foundation = Organization.find_by(name: 'Homöopathen Ohne Grenzen')

ServiceSpecification.create!(
  [
    {
      name: 'Mitarbeit in der Jugendarbeit',
      identification_number: '86574',
      internal_note: 'Aktives Pflichtenheft Jugendarbeit',
      work_clothing_expenses: 230,
      accommodation_expenses: 0,
      location: 'Zürich',
      active: true,
      driving_licenses: [DrivingLicense.find_by(name: 'B')],
      workshops: Workshop.where(name: ['Betreuung von Jugendlichen 1', 'Betreuung von Jugendlichen 2']),
      work_days_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      paid_vacation_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      first_day_expenses: { breakfast: 0, lunch: 900, dinner: 700 },
      last_day_expenses: { breakfast: 400, lunch: 900, dinner: 0 },
      organization: zuckerberg_foundation
    },
    {
      name: 'Transport, Logistik und Hauswirtschaft - Notfall',
      identification_number: '84806',
      internal_note: 'Aktives Pflichtenheft Logistik',
      work_clothing_expenses: 0,
      accommodation_expenses: 0,
      location: 'Zürich, Triemli',
      active: true,
      driving_licenses: [DrivingLicense.find_by(name: 'BE')],
      workshops: [],
      work_days_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      paid_vacation_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      first_day_expenses: { breakfast: 0, lunch: 900, dinner: 700 },
      last_day_expenses: { breakfast: 400, lunch: 900, dinner: 0 },
      organization: zuckerberg_foundation
    },
    {
      name: 'Mitarbeit Sozialpädagogische Zirkusschule',
      identification_number: '71357',
      internal_note: 'Aktives Pflichtenheft',
      work_clothing_expenses: 230,
      accommodation_expenses: 200,
      workshops: [Workshop.find_by(name: 'Kommunikation und Betreuung')],
      location: 'Alvaneu Dorf',
      active: true,
      work_days_expenses: { breakfast: 0, lunch: 0, dinner: 0 },
      paid_vacation_expenses: { breakfast: 0, lunch: 0, dinner: 0 },
      first_day_expenses: { breakfast: 0, lunch: 0, dinner: 0 },
      last_day_expenses: { breakfast: 0, lunch: 0, dinner: 0 },
      organization: homoeopathy_foundation
    }
  ]
)

puts '> Service Specifications seeded'
