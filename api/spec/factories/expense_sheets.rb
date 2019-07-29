# frozen_string_literal: true

FactoryBot.define do
  factory :expense_sheet do
    beginning { Time.zone.today.beginning_of_week - 26.days }
    ending { Time.zone.today.end_of_week - 2.days }
    work_days { 26 - sick_days }
    unpaid_company_holiday_days { 0 }
    paid_company_holiday_days { 0 }
    company_holiday_comment { 'MyString' }
    workfree_days { 2 }
    sick_days { 0 }
    sick_comment { 'MyString' }
    paid_vacation_days { 0 }
    paid_vacation_comment { 'MyString' }
    unpaid_vacation_days { 0 }
    unpaid_vacation_comment { 'MyString' }
    driving_expenses { 2000 }
    driving_expenses_comment { 'MyString' }
    extraordinary_expenses { 0 }
    extraordinary_expenses_comment { 'MyString' }
    clothing_expenses { 3200 }
    clothing_expenses_comment { 'MyString' }
    bank_account_number { 'MyString' }
    state { :open }
    payment_timestamp { nil }
    user

    trait :with_sick_days do
      sick_days { 1 }
    end

    trait :ready_for_payment do
      state { :ready_for_payment }
    end

    trait :payment_in_progress do
      state { :payment_in_progress }
    end

    trait :paid do
      state { :paid }
    end
  end
end
