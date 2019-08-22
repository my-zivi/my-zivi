class MakeRegionalCentersNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column :regional_centers, :name, :string, null: false
    change_column :regional_centers, :short_name, :string, null: false
    change_column :regional_centers, :address, :string, null: false
  end
end
