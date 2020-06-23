# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    primary_line { 'Vollzugsstelle für den Zivildienst ZIVI' }
    secondary_line { 'Regionalzentrum Rüti (ZH)' }
    street { 'Spitalstrasse 31' }
    supplement { 'Postfach' }
    city { 'MyString' }
    zip { 8630 }
  end
end
