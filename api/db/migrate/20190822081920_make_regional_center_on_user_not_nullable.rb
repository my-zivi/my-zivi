class MakeRegionalCenterOnUserNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :regional_center_id, :bigint, null: false
  end
end
