# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    paid_timestamp { nil }
    organization

    trait :paid do
      paid_timestamp { 1.day.ago }
      state { :paid }
    end
  end
end
