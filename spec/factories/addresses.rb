# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    primary_line { 'Vollzugsstelle für den Zivildienst ZIVI' }
    secondary_line { 'Regionalzentrum Rüti (ZH)' }
    street { 'Spitalstrasse 31' }
    supplement { 'Postfach' }
    city { 'Rüti' }
    zip { 8630 }

    trait :civil_servant do
      primary_line { 'Zivi Mustermann' }
      secondary_line { nil }
      street { 'Musterstrasse 99' }
      supplement { nil }
      city { 'Beispielhausen' }
      zip { 1111 }
    end
  end
end
