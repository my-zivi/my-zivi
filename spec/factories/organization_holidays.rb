# frozen_string_literal: true

FactoryBot.define do
  factory :organization_holiday do
    beginning { '2019-04-10' }
    ending { '2019-04-20' }
    description { 'A cool company holiday' }
  end
end
