# frozen_string_literal: true

module ExpenseSheetCalculators
  class SuggestionsCalculator
    WORK_CLOTHING_MAX_PER_SERVICE = 24_000

    extend Forwardable

    def_delegator :day_calculator, :calculate_workfree_days, :suggested_workfree_days
    def_delegator :day_calculator, :calculate_work_days, :suggested_work_days

    def initialize(expense_sheet)
      @expense_sheet = expense_sheet
    end

    def suggestions
      {
        work_days: suggested_work_days,
        workfree_days: suggested_workfree_days,
        paid_company_holiday_days: suggested_paid_company_holiday_days,
        unpaid_company_holiday_days: suggested_unpaid_company_holiday_days,
        clothing_expenses: suggested_clothing_expenses
      }
    end

    def suggested_unpaid_company_holiday_days
      company_holiday_days = day_calculator.calculate_company_holiday_days
      return 0 if company_holiday_days.zero?

      remaining_paid_vacation_days = @expense_sheet.service.remaining_paid_vacation_days
      extra_company_holiday_days = company_holiday_days - remaining_paid_vacation_days

      [0, extra_company_holiday_days].max
    end

    def suggested_paid_company_holiday_days
      company_holiday_days = day_calculator.calculate_company_holiday_days
      return 0 if company_holiday_days.zero?

      [company_holiday_days, @expense_sheet.service.remaining_paid_vacation_days].min
    end

    def suggested_clothing_expenses
      per_day = @expense_sheet.service.service_specification.work_clothing_expenses
      return 0 if per_day.zero?

      max_possible_value = @expense_sheet.calculate_chargeable_days * per_day

      difference_to_max = WORK_CLOTHING_MAX_PER_SERVICE - already_paid_clothing_expenses
      value = [max_possible_value, difference_to_max].min

      [0, value].max
    end

    private

    def already_paid_clothing_expenses
      sheets = @expense_sheet.service.expense_sheets.before_date(@expense_sheet.beginning)

      sheets.sum(&:clothing_expenses)
    end

    def day_calculator
      @day_calculator ||= DayCalculator.new(@expense_sheet.beginning, @expense_sheet.ending)
    end
  end
end
