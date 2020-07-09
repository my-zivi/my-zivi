# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member do
    first_name { 'Hans' }
    last_name { 'Beispiel' }
    phone { '+41 (0) 76 123 45 67' }
    contact_email { nil }
    organization_role { %w[Einsatzleiter Geschäftsführung Leiter\ Zivildienstleistende].sample }
    organization
    association :user, strategy: :build

    after(:create) do |organization_member|
      organization_member.user&.save
    end

    trait :without_login do
      user { nil }
      sequence(:contact_email) { |n| "example#{n}@example.testing" }
    end
  end
end
