# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member do
    first_name { 'Hans' }
    last_name { 'Beispiel' }
    phone { '+41 (0) 76 123 45 67' }
    organization_role { ['Einsatzleiter', 'Geschäftsführung', 'Leiter Zivildienstleistende'].sample }

    trait :with_contact_email do
      sequence(:contact_email) { |n| "example#{n}@example.testing" }
    end

    trait :with_user do
      user

      after(:create) do |organization_member|
        organization_member.user.save
      end
    end
  end
end
