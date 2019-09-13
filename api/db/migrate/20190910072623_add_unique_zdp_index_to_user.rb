class AddUniqueZdpIndexToUser < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :zdp, unique: true
  end
end
