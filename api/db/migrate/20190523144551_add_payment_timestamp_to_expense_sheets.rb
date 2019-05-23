class AddPaymentTimestampToExpenseSheets < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_sheets, :payment_timestamp, :datetime
  end
end
