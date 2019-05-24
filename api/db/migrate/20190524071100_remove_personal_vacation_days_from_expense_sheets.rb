class RemovePersonalVacationDaysFromExpenseSheets < ActiveRecord::Migration[5.2]
  def change
    remove_column :expense_sheets, :personal_vacation_days, :integer
  end
end
