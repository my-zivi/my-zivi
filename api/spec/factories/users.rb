# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "zivi#{n}@gmail.com" }
    sequence(:zdp) { |n| 123_456 + n }
    first_name { 'Zivi' }
    last_name { 'Mustermann' }
    address { 'Bahnstrasse 18b' }
    zip { 8603 }
    city { 'Schwerzenbach' }
    hometown { 'Wallisellen' }
    birthday { '2000-04-27' }
    phone { '+41 (0) 76 123 45 67' }
    bank_iban { 'CH9300762011623852957' }
    health_insurance { 'SWO General Health Insurance ltd.' }
    work_experience { 'Überqualifiziert' }
    driving_licence_b { true }
    driving_licence_be { false }
    internal_note { 'Mag den Gül; Nimmt nur Pesto Sauce beim Pasta-Mondo' }
    chainsaw_workshop { false }
    password { '123456' }
    role { :civil_servant }
    regional_center

    trait :admin do
      role { :admin }
    end
  end
end
