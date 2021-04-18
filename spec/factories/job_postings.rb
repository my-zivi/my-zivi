# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting do
    title { 'Gruppeneinsatz Naturschutz' }
    sequence(:link) { |i| "https://www.example.com/#{i}" }
    description { Faker::Lorem.paragraph }
    publication_date { 3.days.ago }
    icon_url { 'https://picsum.photos/40' }
    company { 'MyCompany' }
  end
end
