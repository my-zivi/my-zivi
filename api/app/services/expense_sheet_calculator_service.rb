# frozen_string_literal: true

class ExpenseSheetCalculatorService
  WORK_CLOTHING_MAX_PER_SERVICE = 24_000

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

    day_sum + @expense_sheet.driving_expenses + calculate_work_clothing_expenses
  end

  def calculate_work_clothing_expenses
    sheets = @expense_sheet.service.expense_sheets.before_date(@expense_sheet.beginning)
    already_paid = sheets.sum { |sheet| sheet.public_send :calculate_work_clothing_expenses }

    per_day = @expense_sheet.service.service_specification.work_clothing_expenses
    value = calculate_chargeable_days * per_day
    future_already_paid = already_paid + value

    return WORK_CLOTHING_MAX_PER_SERVICE - already_paid if future_already_paid > WORK_CLOTHING_MAX_PER_SERVICE

    value
  end

  def calculate_chargeable_days
    @expense_sheet.duration - @expense_sheet.unpaid_vacation_days
  end

  private

  def calculate_default_days(count)
    calculate_values(count, @specification.work_days_expenses)
  end

  def calculate_values(count, day_spec)
    expenses = {
      pocket_money: @specification.pocket_money,
      accommodation: @specification.accommodation_expenses
    }

    expenses.merge(day_spec.symbolize_keys.slice(:breakfast, :lunch, :dinner))
            .yield_self { |full_expenses| full_expenses.merge(total: count * full_expenses.values.sum) }
  end
end
