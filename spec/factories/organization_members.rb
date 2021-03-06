# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { '+41 (0) 76 123 45 67' }
    contact_email { nil }
    organization_role { %w[Einsatzleiter Geschäftsführung Leiter\ Zivildienstleistende].sample }
    organization
    association :user, strategy: :build, factory: %i[user confirmed]

    after(:create) do |organization_member|
      organization_member.user&.save
    end

    trait :without_login do
      user { nil }
      sequence(:contact_email) { |n| "example#{n}@example.testing" }
    end
  end
end
