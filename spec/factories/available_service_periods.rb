# frozen_string_literal: true

FactoryBot.define do
  factory :available_service_period do
    beginning { '2021-06-07' }
    ending { '2022-06-07' }
  end
end
