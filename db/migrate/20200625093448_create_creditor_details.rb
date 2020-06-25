class CreateCreditorDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :creditor_details do |t|
      t.string :bic
      t.string :iban

      t.timestamps
    end
  end
end
