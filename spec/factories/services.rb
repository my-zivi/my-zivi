# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    beginning { '2018-11-05' }
    ending { '2018-11-30' }
    confirmation_date { '2018-09-15' }
    service_type { :normal }
    last_service { false }
    feedback_mail_sent { false }
    service_specification
    association :civil_servant, :full

    trait :unconfirmed do
      confirmation_date { nil }
    end

    trait :long do
      beginning { '2018-11-05' }
      ending { '2019-08-02' }
      service_type { :long }
    end

    trait :last do
      last_service { true }
    end
  end
end