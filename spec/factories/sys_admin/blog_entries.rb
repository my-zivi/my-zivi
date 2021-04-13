# frozen_string_literal: true

FactoryBot.define do
  factory :blog_entry, class: 'BlogEntry' do
    title { 'MyString' }
    body { 'MyText' }
    author { 'MyString' }
  end
end
