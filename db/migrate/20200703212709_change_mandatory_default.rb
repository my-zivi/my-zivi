class ChangeMandatoryDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :service_specifications_workshops, :mandatory, true
    change_column_default :driving_licenses_service_specifications, :mandatory, true
  end
end
