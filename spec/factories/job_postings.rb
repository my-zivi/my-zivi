# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting do
    title { 'Gruppeneinsatz Naturschutz' }
    publication_date { 3.days.ago }
    required_skills { 'abgeschlossene Berufsausbildung' }
    preferred_skills { 'PC-Kenntnisse' }
    canton { 'ZH' }
    sequence(:identification_number) { |i| i }
    category { JobPosting.categories[:nature_conservancy] }
    sub_category { JobPosting.sub_categories[:landscaping_and_gardening] }
    language { JobPosting.languages[:german] }
    organization_name { 'MyCompany' }
    minimum_service_months { 1 }
    contact_information { 'Sir Dr. Roland Hutter' }
    published { true }
    relevancy { JobPosting.relevancies[:normal] }
    brief_description { 'Lorem ipsum dolor sit amet' }
    featured_as_new { false }
    priority_program { true }
    description do
      <<~HTML.squish
        <h5>Lorem ipsum dolor sit amet,</h5>
        consectetur adipiscing elit.
        <ul>
          <li>a est vel tortor porttitor molestie</li>
          <li>Etiam posuere ex elementum arcu blandit sagittis.</li>
        </ul>
        Aenean viverra elit sed dictum malesuada. Mauris semper erat tortor,
        in placerat sapien pharetra eu. Aliquam dignissim diam sed purus ultrices finibus. Mauris velit nisl, commodo
        sed dapibus et, fringilla non nisi. Maecenas eu est accumsan, congue mauris vitae, egestas magna. Aliquam
        pharetra vitae arcu id gravida.
      HTML
    end

    trait :claimed_by_organization do
      organization_name { nil }
      organization
    end

    trait :with_workshops do
      after(:build) do |job_posting|
        job_posting.workshops.push(
          build(:workshop, name: 'Betreuung von Jugendlichen 1'),
          build(:workshop, name: 'Betreuung von Jugendlichen 2')
        )
      end
    end

    trait :with_available_service_periods do
      after(:build) do |job_posting|
        job_posting.available_service_periods << build(:available_service_period)
      end
    end
  end
end
