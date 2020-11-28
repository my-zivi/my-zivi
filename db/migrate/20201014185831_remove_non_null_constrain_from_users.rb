class RemoveNonNullConstrainFromUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :referencee_id, true
    change_column_null :users, :referencee_type, true
    change_column_default :users, :language, from: nil, to: 'de'
  end
end
