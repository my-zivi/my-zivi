class RemoveEligiblePersonalVacationDaysFromServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :services, :eligible_personal_vacation_days, :integer
  end
end
