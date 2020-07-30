# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :mailing_list do
    email { Faker::Internet.email }
    organization { Faker::Company.name }
    telephone { Faker::PhoneNumber.cell_phone }
    name { Faker::Name.name }
  end
end
