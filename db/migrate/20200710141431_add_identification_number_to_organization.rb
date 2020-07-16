class AddIdentificationNumberToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :identification_number, :string, null: false
  end
end
