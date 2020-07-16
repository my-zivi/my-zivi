class AddLanguageToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :language, :string, null: false
  end
end
