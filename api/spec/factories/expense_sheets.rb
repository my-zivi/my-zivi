# frozen_string_literal: true

FactoryBot.define do
  factory :expense_sheet do
    beginning { (Time.zone.today - 3.weeks).beginning_of_week }
    ending { (Time.zone.today - 3.weeks).end_of_week }
    work_days { 5 - ill_days }
    company_holiday_unpaid_days { 0 }
    company_holiday_paid_days { 0 }
    company_holiday_comment { 'MyString' }
    workfree_days { 2 }
    ill_days { 0 }
    ill_comment { 'MyString' }
    personal_vacation_days { 0 }
    paid_vacation_days { 0 }
    paid_vacation_comment { 'MyString' }
    unpaid_vacation_days { 0 }
    unpaid_vacation_comment { 'MyString' }
    driving_charges { 2000 }
    driving_charges_comment { 'MyString' }
    extraordinarily_expenses { 0 }
    extraordinarily_expenses_comment { 'MyString' }
    clothes_expenses { 3200 }
    clothes_expenses_comment { 'MyString' }
    bank_account_number { 'MyString' }
    state { ExpenseSheet.states[:open] }
    user

    trait :with_ill_days do
      ill_days { 1 }
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
