class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :user, foreign_key: true, null: false
      t.references :service_specification, foreign_key: true, null: false
      t.date :beginning, null: false
      t.date :ending, null: false
      t.date :confirmation_date
      t.integer :eligible_personal_vacation_days, null: false
      t.integer :service_type, null: false, default: 0
      t.boolean :first_swo_service, null: false, default: true
      t.boolean :long_service, null: false, default: false
      t.boolean :probation_service, null: false, default: false
      t.boolean :feedback_mail_sent, null: false, default: false

      t.timestamps
    end
  end
end
