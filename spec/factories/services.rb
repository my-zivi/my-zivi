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
    civil_servant_agreed { true }
    organization_agreed { true }
    association :civil_servant, :full

    trait :civil_servant_agreement_pending do
      civil_servant_agreed { nil }
      civil_servant_decided_at { nil }
    end

    trait :organization_agreement_pending do
      organization_agreed { nil }
      organization_decided_at { nil }
    end

    trait :current do
      beginning { Time.zone.now.at_beginning_of_week - 3.weeks }
      ending { Time.zone.now.at_end_of_week + 1.week - 2.days }
    end

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

    trait :past do
      beginning { 2.months.ago.at_beginning_of_week }
      ending { beginning + 25.days }
    end

    trait :active do
      beginning { 1.week.ago.at_beginning_of_week }
      ending { beginning + 25.days }
      civil_servant_agreed { true }
      civil_servant_decided_at { 2.weeks.ago }
      organization_agreed { true }
      organization_decided_at { 3.weeks.ago }
    end

    trait :future do
      beginning { 2.months.from_now.at_beginning_of_week }
      ending { beginning + 25.days }
    end
  end
end
