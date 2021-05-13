# frozen_string_literal: true

FactoryBot.define do
  factory :blog_entry do
    sequence(:title) { |i| "My cool Blogpost #{i}" }
    subtitle { nil }
    content { 'This is my cool content' }
    description { 'This is my cool description' }
    author { Faker::Name.name }
    published { true }
  end
end
