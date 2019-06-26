# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    beginning { '2018-11-05' }
    ending { '2018-11-30' }
    confirmation_date { '2018-11-01' }
    service_type { :normal }
    first_swo_service { true }
    long_service { false }
    probation_service { false }
    feedback_mail_sent { false }
    service_specification
    user

    trait :unconfirmed do
      confirmation_date { nil }
    end

    trait :long do
      beginning { '2018-11-05' }
      ending { '2019-08-02' }
      first_swo_service { true }
      long_service { true }
    end

    trait :valais do
      association :service_specification, factory: %i[service_specification valais]
    end

    trait :last do
      service_type { :last }
    end
  end
end
