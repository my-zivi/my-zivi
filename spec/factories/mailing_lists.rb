# frozen_string_literal: true

FactoryBot.define do
  factory :mailing_list do
    sequence(:email) { |i| "email#{i}@example.com" }
    organization { 'MyZivi AG' }
    telephone { '+41 79 892 12 34' }
    name { 'Maximilian Muster' }
  end
end
