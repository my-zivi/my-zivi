class AddExpenseSheetsCountToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :expense_sheets_count, :integer
  end
end
