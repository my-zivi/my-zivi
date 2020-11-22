class ChangeExpenseSheetExpensesFieldsToMonetaryFields < ActiveRecord::Migration[6.0]
  def up
    change_column :expense_sheets, :clothing_expenses, :decimal, precision: 8, scale: 2
    change_column :expense_sheets, :driving_expenses, :decimal, precision: 8, scale: 2
    change_column :expense_sheets, :extraordinary_expenses, :decimal, precision: 8, scale: 2
    change_column :expense_sheets, :amount, :decimal, precision: 8, scale: 2
  end

  def down
    change_column :expense_sheets, :clothing_expenses, :integer
    change_column :expense_sheets, :driving_expenses, :integer
    change_column :expense_sheets, :extraordinary_expenses, :integer
    change_column :expense_sheets, :amount, :integer
  end
end
