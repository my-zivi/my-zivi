class AddOrganizationMemberReferencesToServiceSpecification < ActiveRecord::Migration[6.0]
  def change
    add_reference :service_specifications, :contact_person, null: false, foreign_key: { to_table: :organization_members }
    add_reference :service_specifications, :lead_person, null: false, foreign_key: { to_table: :organization_members }
  end
end
