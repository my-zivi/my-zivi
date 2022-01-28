# frozen_string_literal: true

FactoryBot.define do
  factory :civil_servant do
    first_name { 'Zivi' }
    last_name { 'Mustermann' }
    email { 'zivi@example.com' }

    trait :personal_step_completed do
      sequence(:zdp) { |n| 123_456 + n }
      hometown { 'Hintertupfingen' }
      birthday { '2000-04-27' }
      phone { '+41 (0) 76 123 45 67' }
      registration_step { RegistrationStep.new(identifier: RegistrationStep::ALL[0]) }
    end

    trait :address_step_completed do
      personal_step_completed
      association :address, :civil_servant
      registration_step { RegistrationStep.new(identifier: RegistrationStep::ALL[1]) }

      after(:create) do |civil_servant|
        civil_servant.address.update(primary_line: civil_servant.full_name)
      end
    end

    trait :bank_and_insurance_step_completed do
      address_step_completed
      iban { 'CH9300762011623852957' }
      health_insurance { 'Sanicare' }
      registration_step { RegistrationStep.new(identifier: RegistrationStep::ALL[2]) }
    end

    trait :service_specific_step_completed do
      bank_and_insurance_step_completed
      regional_center { RegionalCenter.rueti }
      registration_step { RegistrationStep.new(identifier: RegistrationStep::ALL[3]) }
    end

    trait :full do
      service_specific_step_completed
    end

    trait :with_service do
      transient do
        organization { create :organization, :with_admin }
        service_specification { create :service_specification, organization: organization }
        service_attributes { {} }
        service_traits { [] }
      end

      services do
        [build(:service, :active, *service_traits, service_specification: service_specification, **service_attributes)]
      end

      after(:create) do |civil_servant|
        civil_servant.services.map(&:save)
      end
    end
  end
end
