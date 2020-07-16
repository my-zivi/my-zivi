# frozen_string_literal: true

zuckerberg_foundation = Organization.find_by(name: 'Zuckerberg Foundation')
james = OrganizationMember.find_by(first_name: 'James')
homoeopathy_foundation = Organization.find_by(name: 'Homöopathen Ohne Grenzen')
percy = OrganizationMember.find_by(first_name: 'Percy')

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
      organization: zuckerberg_foundation,
      contact_person: james,
      lead_person: james
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
      organization: zuckerberg_foundation,
      contact_person: james,
      lead_person: james
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
      organization: homoeopathy_foundation,
      contact_person: percy,
      lead_person: percy
    }
  ]
)

puts '> Service Specifications seeded'
