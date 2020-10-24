class AddRegistrationStepToCivilServant < ActiveRecord::Migration[6.0]
  def change
    add_column :civil_servants, :registration_step, :string, null: false, default: RegistrationStep::ALL.first
  end
end
