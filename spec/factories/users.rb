# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.test" }
    password { '12345678' }
  end
end
