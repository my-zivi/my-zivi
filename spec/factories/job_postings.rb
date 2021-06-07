# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting do
    title { 'Gruppeneinsatz Naturschutz' }
    publication_date { 3.days.ago }
    icon_url { 'https://i.picsum.photos/id/458/40/40.jpg?hmac=QK8u-TtdS_88CLa_qvzYyB9aZ6akNFET2fE50QihRUw' }
    organization_name { 'MyCompany' }
    canton { 'Zürich' }
    sequence(:identification_number) { |i| i }
    category { JobPosting.categories[:nature_conservancy] }
    sub_category { JobPosting.sub_categories[:landscape_conservation] }
    language { JobPosting.languages[:german] }
    minimum_service_months { 1 }
    contact_information { 'Sir Dr. Roland Hutter' }
    description do
      <<~HTML.squish
        <h3>Lorem ipsum dolor sit amet,<h3>
        consectetur adipiscing elit. Curabitur a est vel tortor porttitor molestie. Etiam
        posuere ex elementum arcu blandit sagittis. Aenean viverra elit sed dictum malesuada. Mauris semper erat tortor,
        in placerat sapien pharetra eu. Aliquam dignissim diam sed purus ultrices finibus. Mauris velit nisl, commodo
        sed dapibus et, fringilla non nisi. Maecenas eu est accumsan, congue mauris vitae, egestas magna. Aliquam
        pharetra vitae arcu id gravida.
      HTML
    end
  end
end
