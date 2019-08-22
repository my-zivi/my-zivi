class AddLegacyPasswordToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :legacy_password, :string, null: true
  end
end
