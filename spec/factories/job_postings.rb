# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting do
    title { 'Gruppeneinsatz Naturschutz' }
    sequence(:link) { |i| "https://www.example.com/#{i}" }
    description { Faker::Lorem.paragraph }
    publication_date { 3.days.ago }
    icon_url { 'https://i.picsum.photos/id/458/40/40.jpg?hmac=QK8u-TtdS_88CLa_qvzYyB9aZ6akNFET2fE50QihRUw' }
    company { 'MyCompany' }
  end
end
