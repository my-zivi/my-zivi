# frozen_string_literal: true

FactoryBot.define do
  factory :holiday do
    beginning { '2019-04-10' }
    ending { '2019-04-20' }
    holiday_type { :company_holiday }
    description { 'MyString' }
  end
end
