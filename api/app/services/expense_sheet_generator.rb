# frozen_string_literal: true

class ExpenseSheetGenerator
  def initialize(service)
    @service = service
  end

  def create_expense_sheets(beginning: @service.beginning, ending: @service.ending)
    grouped_days = group_days_by_month(beginning..ending)

    grouped_days.map do |month_days|
      beginning = month_days.first
      ending = month_days.last
      create_expense_sheet(beginning, ending)
    end
  end

  def create_missing_expense_sheets
    existing_expense_sheets = @service.expense_sheets.sort_by do |expense_sheet|
      [expense_sheet.beginning, expense_sheet.ending]
    end
    return create_expense_sheets if existing_expense_sheets.count.zero?

    new_beginning = existing_expense_sheets.last.ending + 1.day

    create_expense_sheets beginning: new_beginning
  end

  private

  def group_days_by_month(days)
    days.slice_when { |date| date == date.at_end_of_month }
  end

  def create_expense_sheet(beginning, ending)
    ExpenseSheet.create(
      user: @service.user,
      beginning: beginning,
      ending: ending,
      work_days: DayCalculator.new(beginning, ending).calculate_work_days,
      workfree_days: DayCalculator.new(beginning, ending).calculate_workfree_days,
      # TODO: Where to get bank_account_number from?
      bank_account_number: '4470 (200)'
    )
  end
end
