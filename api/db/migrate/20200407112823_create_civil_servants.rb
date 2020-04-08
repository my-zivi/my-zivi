class CreateCivilServants < ActiveRecord::Migration[6.0]
  def change
    create_table :civil_servants do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :zdp, null: false
      t.string :hometown, null: false
      t.datetime :birthday, null: false
      t.string :phone, null: false
      t.string :iban
      t.string :health_insurance
      t.references :address, null: false
      t.references :regional_center, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
