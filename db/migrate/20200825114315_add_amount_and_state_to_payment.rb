class AddAmountAndStateToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :amount, :integer, null: false, default: 0
    add_column :payments, :state, :integer, null: false, default: 0
  end
end
