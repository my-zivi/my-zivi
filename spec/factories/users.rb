# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.test" }
    password { '12345678' }

    trait :confirmed do
      confirmed_at { 5.minutes.ago }
    end
  end
end
