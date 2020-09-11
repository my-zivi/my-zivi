# frozen_string_literal: true

FactoryBot.define do
  factory :civil_servant do
    sequence(:zdp) { |n| 123_456 + n }
    first_name { 'Zivi' }
    last_name { 'Mustermann' }
    hometown { 'Hintertupfingen' }
    birthday { '2000-04-27' }
    phone { '+41 (0) 76 123 45 67' }
    iban { 'CH9300762011623852957' }
    health_insurance { 'Sanicare' }

    trait :full do
      association :address, :civil_servant
      regional_center
      association :user, strategy: :build, factory: %i[user confirmed]

      after(:create) do |civil_servant|
        civil_servant.user.save
        civil_servant.address.update(primary_line: civil_servant.full_name)
      end
    end

    trait :with_service do
      transient do
        organization { create :organization }
        service_specification { create :service_specification, organization: organization }
        service_attributes { {} }
      end

      services { [build(:service, :active, service_specification: service_specification, **service_attributes)] }

      after(:create) do |civil_servant|
        civil_servant.services.map(&:save)
      end
    end
  end
end
