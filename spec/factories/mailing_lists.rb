# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :mailing_list do
    email { Faker::Internet.email }
    organization { 'MyZivi AG' }
    telephone { '+41 79 892 12 34' }
    name { 'Maximilian Muster' }
  end
end
