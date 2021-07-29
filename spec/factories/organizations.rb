# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    sequence(:identification_number) { |n| 10 + n }
    name { 'MyZivi AG' }
    intro_text { 'This is the best zivi organization' }
    address
    creditor_detail
    subscriptions { [build(:admin_subscription)] }

    trait :with_icon do
      icon { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/example_icon.png'), 'image/png') }
    end

    trait :with_recruiting_subscription do
      subscriptions { [build(:recruiting_subscription)] }
    end
  end
end
