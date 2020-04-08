class MigrateDataFromUserToCivilServant < ActiveRecord::Migration[6.0]
  def up
    rename_column :services, :user_id, :civil_servant_id
    rename_column :expense_sheets, :user_id, :civil_servant_id

    User.all.each do |user|
      address = Address.create!(
        street: user.address,
        zip: user.zip,
        city: user.city
      )

      CivilServant.create!(
        address: address,
        user: user,
        first_name: user.first_name,
        last_name: user.last_name,
        zdp: user.zdp,
        hometown: user.hometown,
        birthday: user.birthday,
        phone: user.phone,
        iban: user.bank_iban,
        health_insurance: user.health_insurance,
        regional_center: user.regional_center,
      )
    end

      # remove_index :users,
    remove_column :users, :address
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :zdp
    remove_column :users, :hometown
    remove_column :users, :birthday
    remove_column :users, :phone
    remove_column :users, :bank_iban
    remove_column :users, :health_insurance
    remove_column :users, :regional_center_id

  end

  def down


    rename_column :services, :civil_servant_id, :user_id
  end
end
