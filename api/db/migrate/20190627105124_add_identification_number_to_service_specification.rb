class AddIdentificationNumberToServiceSpecification < ActiveRecord::Migration[5.2]
  def change
    add_column :service_specifications, :identification_number, :string, null: false
    add_index :service_specifications, :identification_number, unique: true
  end
end
