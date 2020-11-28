class AddAgreementFlagsToServices < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :civil_servant_agreed, :boolean, null: false, default: false
    add_column :services, :civil_servant_agreed_on, :datetime
    add_column :services, :organization_agreed, :boolean, null: false, default: false
    add_column :services, :organization_agreed_on, :datetime
  end
end
