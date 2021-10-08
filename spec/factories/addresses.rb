# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    sequence(:primary_line) { |n| "Vollzugsstelle für den Zivildienst ZIVI (#{n})" }
    secondary_line { 'Regionalzentrum Rüti (ZH)' }
    sequence(:street) { |n| "Spitalstrasse #{31 + n}" }
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

    trait :organization do
      primary_line { 'Stiftung XYZ' }
      secondary_line { nil }
      street { 'Rennweg 12' }
      supplement { nil }
      city { 'Zürich' }
      zip { 8000 }
    end

    trait :with_coordinates do
      latitude { 47.38831865 }
      longitude { 8.48376134687825 }
    end
  end
end
