# frozen_string_literal: true

FactoryBot.define do
  factory :sys_admin do
    sequence(:email) { |n| "sysadmin#{n}@example.com" }
    password { '12345678' }
  end
end
