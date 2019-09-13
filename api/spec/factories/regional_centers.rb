# frozen_string_literal: true

FactoryBot.define do
  factory :regional_center do
    name { 'Regionalzentrum Rüti/ZH' }
    short_name { 'Ru' }
    address do
      'Vollzugsstelle für den Zivildienst ZIVI, Regionalzentrum Rüti (ZH), Spitalstrasse 31, Postfach, 8630 Rüti (ZH)'
    end
  end
end
