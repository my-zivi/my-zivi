# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { '+41 (0) 76 123 45 67' }
    sequence(:email) { |n| "example#{n}@example.testing" }
    organization_role { ['Einsatzleiter', 'Geschäftsführung', 'Leiter Zivildienstleistende'].sample }
    organization

    trait :without_login do
      user { nil }

      # TODO
    end

    trait :with_admin_subscribed_organization do
      association(:organization, factory: %i[organization with_admin])
    end

    trait :with_recruiting_subscribed_organization do
      association(:organization, factory: %i[organization with_recruiting])
    end
  end
end
