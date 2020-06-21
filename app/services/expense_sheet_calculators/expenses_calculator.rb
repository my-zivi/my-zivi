# frozen_string_literal: true

module ExpenseSheetCalculators
  class ExpensesCalculator
    def initialize(expense_sheet)
      @expense_sheet = expense_sheet
      @service = expense_sheet.service
      @specification = expense_sheet.service.service_specification
    end

    def calculate_first_day
      count = @expense_sheet.at_service_beginning? ? 1 : 0
      calculate_values(count, @specification.first_day_expenses)
    end

    def calculate_work_days
      calculate_default_days(@expense_sheet.work_days_count)
    end

    def calculate_last_day
      count = @expense_sheet.at_service_ending? ? 1 : 0
      calculate_values(count, @specification.last_day_expenses)
    end

    def calculate_workfree_days
      calculate_default_days(@expense_sheet.workfree_days)
    end

    def calculate_sick_days
      calculate_default_days(@expense_sheet.sick_days)
    end

    def calculate_paid_vacation_days
      calculate_default_days(@expense_sheet.paid_vacation_days)
    end

    def calculate_unpaid_vacation_days
      {
        pocket_money: 0,
        accommodation: 0,
        breakfast: 0,
        lunch: 0,
        dinner: 0,
        total: 0
      }
    end

    def calculate_full_expenses
      day_sum = [
        calculate_first_day,
        calculate_work_days,
        calculate_last_day,
        calculate_workfree_days,
        calculate_sick_days,
        calculate_paid_vacation_days,
        calculate_unpaid_vacation_days
      ].sum { |values| values[:total] }

      day_sum + calculate_static_expenses
    end

    def calculate_chargeable_days
      @expense_sheet.duration - @expense_sheet.total_unpaid_vacation_days
    end

    private

    def calculate_static_expenses
      @expense_sheet.driving_expenses + @expense_sheet.clothing_expenses + @expense_sheet.extraordinary_expenses
    end

    def calculate_default_days(count)
      calculate_values(count, @specification.work_days_expenses)
    end

    def calculate_values(count, day_spec)
      expenses = {
        pocket_money: ServiceSpecification::POCKET_MONEY,
        accommodation: @specification.accommodation_expenses
      }

      expenses.merge(day_spec.symbolize_keys.slice(:breakfast, :lunch, :dinner))
              .yield_self { |full_expenses| full_expenses.merge(total: count * full_expenses.values.sum) }
    end
  end
end
