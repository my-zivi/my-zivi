class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.date :beginning, null: false
      t.date :ending, null: false
      t.integer :holiday_type, null: false, default: 1
      t.string :description, null: false

      t.timestamps
    end
  end
end
