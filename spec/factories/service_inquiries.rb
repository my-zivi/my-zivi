FactoryBot.define do
  factory :service_inquiry do
    name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    service_beginning { "2022-03-06 11:42:56" }
    service_ending { "2022-03-06 11:42:56" }
    message { "MyText" }
    job_posting { nil }
  end
end
