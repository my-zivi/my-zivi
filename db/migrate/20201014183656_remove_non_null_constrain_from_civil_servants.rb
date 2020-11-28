class RemoveNonNullConstrainFromCivilServants < ActiveRecord::Migration[6.0]
  def change
    change_column_null :civil_servants, :zdp, true
    change_column_null :civil_servants, :hometown, true
    change_column_null :civil_servants, :birthday, true
    change_column_null :civil_servants, :phone, true
    change_column_null :civil_servants, :iban, true
    change_column_null :civil_servants, :health_insurance, true
    change_column_null :civil_servants, :regional_center, true
    change_column_null :civil_servants, :address_id, true
  end
end
