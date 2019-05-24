# frozen_string_literal: true

FactoryBot.define do
  factory :expense_sheet do
    beginning { (Time.zone.today - 3.weeks).beginning_of_week }
    ending { (Time.zone.today - 3.weeks).end_of_week }
    work_days { 5 - sick_days }
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
    state { ExpenseSheet.states[:open] }
    user

    trait :with_sick_days do
      sick_days { 1 }
    end

    trait :ready_for_payment do
      state { ExpenseSheet.states[:ready_for_payment] }
    end

    trait :payment_in_progress do
      state { ExpenseSheet.states[:payment_in_progress] }
    end

    trait :paid do
      state { ExpenseSheet.states[:paid] }
    end
  end
end
