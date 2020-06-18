# frozen_string_literal: true

FactoryBot.define do
  factory :service_specification do
    name { 'MyServiceSpecification' }
    sequence(:identification_number) { |i| (82_844 + i).to_s }
    internal_note { 'Service specification a' }
    work_clothing_expenses { 230 }
    accommodation_expenses { 0 }
    location { 'zurich' }
    active { true }
    work_days_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }
    paid_vacation_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }
    first_day_expenses { { breakfast: 0, lunch: 900, dinner: 700 } }
    last_day_expenses { { breakfast: 400, lunch: 900, dinner: 0 } }
    organization

    trait :valais do
      location { 'valais' }
    end
  end
end
