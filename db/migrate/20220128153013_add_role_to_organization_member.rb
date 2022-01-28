class AddRoleToOrganizationMember < ActiveRecord::Migration[6.1]
  def change
    add_column :organization_members, :privilege, :integer, default: 0, null: false
  end
end
