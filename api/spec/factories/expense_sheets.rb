# frozen_string_literal: true

FactoryBot.define do
  factory :expense_sheet do
    beginning { '2018-11-05' }
    ending { '2018-11-30' }
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
      to_create { |expense_sheet| expense_sheet.save!(validate: false) }

      state { :payment_in_progress }
      payment_timestamp { Time.zone.at(1_564_471_897) }
    end

    trait :paid do
      to_create { |expense_sheet| expense_sheet.save!(validate: false) }

      state { :paid }
      payment_timestamp { Time.zone.at(1_564_471_897) }
    end
  end
end
