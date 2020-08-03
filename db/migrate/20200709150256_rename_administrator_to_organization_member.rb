class RenameAdministratorToOrganizationMember < ActiveRecord::Migration[6.0]
  def change
    rename_table :administrators, :organization_members

    change_table :organization_members, bulk: true do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :organization_role, null: false
      t.string :contact_email, null: true

      t.index :contact_email, unique: true
    end
  end
end
