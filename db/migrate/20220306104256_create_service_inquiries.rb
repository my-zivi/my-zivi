class CreateServiceInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :service_inquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :service_beginning, null: false
      t.string :service_duration, null: false
      t.text :message, null: false
      t.references :job_posting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
