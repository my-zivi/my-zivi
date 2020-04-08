# frozen_string_literal: true

FactoryBot.define do
  factory :civil_servant do
    first_name { 'Zivi' }
    last_name { 'Mustermann' }
    sequence(:zdp) { |n| 123_456 + n }
    hometown { 'Wallisellen' }
    birthday { '2000-04-27' }
    phone { '+41 (0) 76 123 45 67' }
    iban { 'CH9300762011623852957' }
    health_insurance { 'myZivi health' }
    regional_center
    address
    user
  end
end
