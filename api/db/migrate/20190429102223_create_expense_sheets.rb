class CreateExpenseSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_sheets do |t|
      t.date :beginning, null: false
      t.date :ending, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :work_days, null: false
      t.integer :company_holiday_unpaid_days, default: 0, null: false
      t.integer :company_holiday_paid_days, default: 0, null: false
      t.string :company_holiday_comment
      t.integer :workfree_days, default: 0, null: false
      t.integer :ill_days, default: 0, null: false
      t.string :ill_comment
      t.integer :personal_vacation_days, default: 0, null: false
      t.integer :paid_vacation_days, default: 0, null: false
      t.string :paid_vacation_comment
      t.integer :unpaid_vacation_days, default: 0, null: false
      t.string :unpaid_vacation_comment
      t.integer :driving_charges, default: 0, null: false
      t.string :driving_charges_comment
      t.integer :extraordinarily_expenses, default: 0, null: false
      t.string :extraordinarily_expenses_comment
      t.integer :clothes_expenses, default: 0, null: false
      t.string :clothes_expenses_comment
      t.string :bank_account_number, null: false
      t.integer :state, default: 0, null: false

      t.timestamps
    end
  end
end
