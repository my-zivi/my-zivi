class RenameExpenseSheetsColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :expense_sheets, :driving_charges, :driving_expenses
    rename_column :expense_sheets, :driving_charges_comment, :driving_expenses_comment
    rename_column :expense_sheets, :ill_days, :sick_days
    rename_column :expense_sheets, :ill_comment, :sick_comment
    rename_column :expense_sheets, :clothes_expenses, :clothing_expenses
    rename_column :expense_sheets, :clothes_expenses_comment, :clothing_expenses_comment
    rename_column :expense_sheets, :extraordinarily_expenses, :extraordinary_expenses
    rename_column :expense_sheets, :extraordinarily_expenses_comment, :extraordinary_expenses_comment
    rename_column :expense_sheets, :company_holiday_paid_days, :paid_company_holiday_days
    rename_column :expense_sheets, :company_holiday_unpaid_days, :unpaid_company_holiday_days
  end
end
