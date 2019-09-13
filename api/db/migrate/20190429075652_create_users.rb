class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.integer :zdp, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :address, null: false
      t.integer :zip, null: false
      t.integer :role, default: 2, null: false
      t.string :city, null: false
      t.string :hometown, null: false
      t.date :birthday, null: false
      t.string :phone, null: false
      t.string :bank_iban, null: false
      t.string :health_insurance, null: false
      t.text :work_experience
      t.boolean :driving_licence_b, default: false, null: false
      t.boolean :driving_licence_be, default: false, null: false
      t.references :regional_center, foreign_key: true
      t.text :internal_note
      t.boolean :chainsaw_workshop, default: false, null: false

      t.timestamps
    end
  end
end
