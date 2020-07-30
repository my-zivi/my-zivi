class CreateMailingLists < ActiveRecord::Migration[6.0]
  def change
    create_table :mailing_lists do |t|
      t.string :email, null: false, unique: true

      t.timestamps
    end
  end
end
