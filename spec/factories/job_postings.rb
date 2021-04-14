# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting do
    title { 'MyString' }
    link { 'MyString' }
    description { 'MyText' }
    publication_date { '2021-04-14' }
  end
end
