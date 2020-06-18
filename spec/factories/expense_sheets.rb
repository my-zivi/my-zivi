# frozen_string_literal: true

FactoryBot.define do
  factory :expense_sheet do
    beginning { '2018-11-05' }
    ending { '2018-11-30' }
    work_days { 26 - sick_days }
    unpaid_company_holiday_days { 0 }
    paid_company_holiday_days { 0 }
    company_holiday_comment { 'My company holiday comment' }
    workfree_days { 2 }
    sick_days { 0 }
    sick_comment { 'He/She was very sick' }
    paid_vacation_days { 0 }
    paid_vacation_comment { 'He/She separately needed vacation' }
    unpaid_vacation_days { 0 }
    unpaid_vacation_comment { 'MyString' }
    driving_expenses { 2000 }
    driving_expenses_comment { 'MyString' }
    extraordinary_expenses { 0 }
    extraordinary_expenses_comment { 'MyString' }
    clothing_expenses { 3200 }
    clothing_expenses_comment { 'MyString' }
    state { :editable }
    credited_iban { nil }

    trait :with_sick_days do
      sick_days { 1 }
    end

    trait :with_service do
      service
    end
  end
end
