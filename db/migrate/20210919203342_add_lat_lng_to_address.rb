class AddLatLngToAddress < ActiveRecord::Migration[6.1]
  def change
    change_table :addresses, bulk: true do |t|
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
    end
  end
end
