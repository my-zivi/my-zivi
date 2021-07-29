# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    sequence(:identification_number) { |n| 10 + n }
    name { 'MyZivi AG' }
    intro_text { 'This is the best zivi organization' }
    address
    creditor_detail
    subscriptions { [] }

    trait :with_icon do
      icon { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/example_icon.png'), 'image/png') }
    end

    trait :with_admin do
      subscriptions { [build(:admin_subscription)] }
    end

    trait :with_recruiting do
      subscriptions { [build(:recruiting_subscription)] }
    end
  end
end
