class CreateMailingLists < ActiveRecord::Migration[6.0]
  def change
    create_table :mailing_lists do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :telephone, null: false
      t.string :organization, null: false

      t.index :email, unique: true

      t.timestamps
    end
  end
end
