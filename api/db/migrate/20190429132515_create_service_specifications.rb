 class CreateServiceSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :service_specifications do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.integer :working_clothes_expenses, null: false
      t.integer :accommodation_expenses, null: false
      t.text :work_days_expenses, null: false
      t.text :paid_vacation_expense, null: false
      t.text :first_day_expense, null: false
      t.text :last_day_expense, null: false
      t.string :location, default: 'zh'
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
