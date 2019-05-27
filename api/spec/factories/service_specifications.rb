# frozen_string_literal: true

FactoryBot.define do
  factory :service_specification do
    name { 'MyServiceSpecification' }
    short_name { 'M' }
    work_clothing_expenses { 1000 }
    accommodation_expenses { 0 }
    location { 'zurich' }
    active { false }
    work_days_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }
    paid_vacation_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }
    first_day_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }
    last_day_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }

    trait :valais do
      location { 'valais' }
    end
  end
end
