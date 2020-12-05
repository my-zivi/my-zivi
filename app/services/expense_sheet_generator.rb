# frozen_string_literal: true

class ExpenseSheetGenerator
  def initialize(service)
    @service = service
  end

  def create_expense_sheets(beginning: @service.beginning, ending: @service.ending)
    grouped_days = group_days_by_month(beginning..ending)

    ExpenseSheet.transaction do
      grouped_days.map do |month_days|
        create_expense_sheet(*month_days)
      end

      true
    end
  rescue StandardError => e
    # TODO: Track and report errors
    p e
    false
  end

  def create_missing_expense_sheets
    existing_expense_sheets = @service.expense_sheets.sort_by do |expense_sheet|
      [expense_sheet.beginning, expense_sheet.ending]
    end
    return create_expense_sheets if existing_expense_sheets.count.zero?

    new_beginning = existing_expense_sheets.last.ending + 1.day

    create_expense_sheets beginning: new_beginning
  end

  def create_additional_expense_sheet
    service_ending = @service.ending
    create_expense_sheet(service_ending, service_ending)
  end

  private

  def group_days_by_month(days)
    days.group_by(&:month).values.map(&:minmax)
  end

  def create_expense_sheet(beginning, ending)
    ExpenseSheet.create!(
      service: @service,
      beginning: beginning,
      ending: ending,
      work_days: DayCalculator.new(beginning, ending).calculate_work_days,
      workfree_days: DayCalculator.new(beginning, ending).calculate_workfree_days,
      # TODO: Where to get bank_account_number from?
      credited_iban: @service.civil_servant.iban
    )
  end
end
