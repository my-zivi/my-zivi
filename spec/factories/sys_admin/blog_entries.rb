# frozen_string_literal: true

FactoryBot.define do
  factory :blog_entry, class: 'BlogEntry' do
    sequence(:title) { |i| "My cool Blogpost #{i}" }
    content { 'This is my cool content' }
    description { 'This is my cool description' }
    author { 'Max Mustermann' }
    published { true }
  end
end
