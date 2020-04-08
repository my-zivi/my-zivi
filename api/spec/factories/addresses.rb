# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street { 'Bahnstrasse 18b' }
    zip { 8603 }
    city { 'Schwerzenbach' }
    primary_line { 'Person Standard' }

    trait :second_line do
      second_line {}
    end
  end
end
