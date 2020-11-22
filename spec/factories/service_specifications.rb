# frozen_string_literal: true

FactoryBot.define do
  factory :service_specification do
    name { 'MyServiceSpecification' }
    sequence(:identification_number) { |i| (82_844 + i).to_s }
    internal_note { 'Service specification a' }
    work_clothing_expenses { 2.3 }
    accommodation_expenses { 0 }
    location { 'zurich' }
    active { true }
    work_days_expenses { { 'breakfast' => 4, 'lunch' => 9, 'dinner' => 7 } }
    paid_vacation_expenses { { 'breakfast' => 4, 'lunch' => 9, 'dinner' => 7 } }
    first_day_expenses { { 'breakfast' => 0, 'lunch' => 9, 'dinner' => 7 } }
    last_day_expenses { { 'breakfast' => 4, 'lunch' => 9, 'dinner' => 0 } }
    association :organization
    association :contact_person, factory: :organization_member
    association :lead_person, factory: :organization_member

    trait :valais do
      location { 'valais' }
    end
  end
end
