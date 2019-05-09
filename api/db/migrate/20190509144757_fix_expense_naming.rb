class FixExpenseNaming < ActiveRecord::Migration[5.2]
  def change
    rename_column :service_specifications, :paid_vacation_expense, :paid_vacation_expenses
    rename_column :service_specifications, :first_day_expense, :first_day_expenses
    rename_column :service_specifications, :last_day_expense, :last_day_expenses
  end
end
