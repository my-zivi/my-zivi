# frozen_string_literal: true

FactoryBot.define do
  factory :service_inquiry do
    name { Faker::Name.name }
    sequence(:email) { |i| "mail#{i}@example.com" }
    phone { '044 123 34 45' }
    service_beginning { 1.month.from_now.iso8601 }
    service_duration { '1 Monat' }
    message { 'That is my inquiry!' }
    job_posting
  end
end
