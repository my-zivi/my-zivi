class AddRegistrationStepToCivilServant < ActiveRecord::Migration[6.0]
  def change
    add_column :civil_servants, :registration_step, :string
  end
end
