# frozen_string_literal: true

# rubocop:disable Lint/EmptyBlock
FactoryBot.define do
  factory :admin_subscription, class: 'Subscriptions::Admin' do
  end

  factory :recruiting_subscription, class: 'Subscriptions::Recruiting' do
  end
end
# rubocop:enable Lint/EmptyBlock
