# frozen_string_literal: true

FactoryBot.define do
  factory :service_inquiry do
    name { Faker::Name.name }
    sequence(:email) { |i| "mail#{i}@example.com" }
    phone { '044 123 34 45' }
    service_beginning { 1.month.from_now }
    service_ending { 2.months.from_now }
    message { 'That is my inquiry!' }
    job_posting
  end
end
