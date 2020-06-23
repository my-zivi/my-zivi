# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    paid_timestamp { 1.day.ago }
    organization
  end
end
