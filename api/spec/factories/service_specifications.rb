# frozen_string_literal: true

FactoryBot.define do
  factory :service_specification do
    name { 'MyString' }
    short_name { 'MyString' }
    working_clothes_expenses { 1000 }
    accommodation_expenses { 0 }
    location { ServiceSpecification.locations[:zh] }
    active { false }
    work_days_expenses { { breakfast: 400, lunch: 900, dinner: 700 } }
    paid_vacation_expense { { breakfast: 400, lunch: 900, dinner: 700 } }
    first_day_expense { { breakfast: 400, lunch: 900, dinner: 700 } }
    last_day_expense { { breakfast: 400, lunch: 900, dinner: 700 } }
  end
end
