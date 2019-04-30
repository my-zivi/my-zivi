 class CreateServiceSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :service_specifications do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.integer :working_clothes_expenses, null: false
      t.integer :accommodation_expenses, null: false
      t.json :work_days_expenses, null: false
      t.json :paid_vacation_expense, null: false
      t.json :first_day_expense, null: false
      t.json :last_day_expense, null: false
      t.string :language, default: 'de'
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
