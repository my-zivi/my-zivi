# frozen_string_literal: true

FactoryBot.define do
  factory :organization_holiday do
    beginning { '2019-04-10' }
    ending { '2019-04-20' }
    sequence(:description) { |i| "A cool company holiday No. #{i}" }
    organization

    trait :in_future do
      beginning { 1.week.from_now }
      ending { 2.weeks.from_now }
    end
  end
end
