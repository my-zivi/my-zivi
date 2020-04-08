# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "zivi#{n}@gmail.com" }
    password { '123456' }
    role { :civil_servant }

    trait :admin do
      role { :admin }
    end
  end
end
