class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :zip
      t.string :city
      t.string :primary_line
      t.string :secondary_line

      t.timestamps
    end
  end
end
