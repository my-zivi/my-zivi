class CreateRegionalCenters < ActiveRecord::Migration[5.2]
  def change
    create_table :regional_centers do |t|
      t.string :name
      t.string :address
      t.string :short_name

      t.timestamps
    end
  end
end
