# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'zivi@gmail.com' }
    zdp { 123_456 }
    first_name { 'Zivi' }
    last_name { 'Mustermann' }
    address { 'Bahnstrasse 18b' }
    zip { 8603 }
    city { 'Schwerzenbach' }
    hometown { 'Wallisellen' }
    birthday { '2000-04-27' }
    phone { '+41 (0) 76 123 45 67' }
    bank_iban { 'CH93 0076 2011 6238 5295 7' }
    health_insurance { 'SWO General Healt Insurance ltd.' }
    work_experience { 'Überqualifiziert' }
    driving_licence_b { true }
    driving_licence_be { false }
    internal_note { 'Mag den Gül; Nimmt nur Pesto Sauce beim Pasta-Mondo' }
    chainsaw_workshop { false }
    regional_center
    role { User.roles[:civil_servant] }
  end
end
