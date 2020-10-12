class DropRegionalCenters < ActiveRecord::Migration[6.0]
  def change
    remove_column :civil_servants, :regional_center_id, :bigint
    add_column :civil_servants, :regional_center, :string, null: false, default: 'rüti'

    drop_table :regional_centers, force: :cascade do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.bigint :address_id, null: false
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
      t.index ['address_id'], name: 'index_regional_centers_on_address_id'
    end

    change_column_default :civil_servants, :regional_center, from: 'rüti', to: nil
  end
end
