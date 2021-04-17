# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting do
    title { 'Gruppeneinsatz Naturschutz' }
    link { 'https://www.example.com/' }
    description { Faker::Lorem.paragraph }
    publication_date { 3.days.ago }
    icon_url { 'https://picsum.photos/40' }
    company { 'MyCompany' }
  end
end
