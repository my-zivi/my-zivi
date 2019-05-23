class RenameServiceSpecificationsColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :service_specifications, :working_clothes_expenses, :work_clothing_expenses
  end
end
