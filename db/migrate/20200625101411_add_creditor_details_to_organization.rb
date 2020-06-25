class AddCreditorDetailsToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_reference :organizations, :creditor_detail, foreign_key: true
  end
end
