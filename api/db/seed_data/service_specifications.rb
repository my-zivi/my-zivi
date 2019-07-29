# frozen_string_literal: true

ServiceSpecification.create!(
  [
    {
      name: 'Gruppeneinsätze, Feldarbeiten',
      identification_number: '19532',
      short_name: 'F',
      work_clothing_expenses: 230,
      accommodation_expenses: 0,
      work_days_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      paid_vacation_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      first_day_expenses: { breakfast: 0, lunch: 900, dinner: 700 },
      last_day_expenses: { breakfast: 400, lunch: 900, dinner: 0 },
      location: :zurich,
      active: true
    },
    {
      name: 'Feldarbeiten (ab 06.07.2016)',
      identification_number: '72466',
      short_name: 'F',
      work_clothing_expenses: 0,
      accommodation_expenses: 0,
      work_days_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      paid_vacation_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      first_day_expenses: { breakfast: 0, lunch: 900, dinner: 700 },
      last_day_expenses: { breakfast: 400, lunch: 900, dinner: 0 },
      location: :zurich,
      active: true
    },
    {
      name: 'VS Feldarbeiten',
      identification_number: '82844',
      short_name: 'W',
      work_clothing_expenses: 230,
      accommodation_expenses: 0,
      work_days_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      paid_vacation_expenses: { breakfast: 400, lunch: 900, dinner: 700 },
      first_day_expenses: { breakfast: 0, lunch: 900, dinner: 700 },
      last_day_expenses: { breakfast: 400, lunch: 900, dinner: 0 },
      location: :valais,
      active: true
    }
  ]
)
