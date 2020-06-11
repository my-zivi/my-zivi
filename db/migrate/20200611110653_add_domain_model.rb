class AddDomainModel < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :primary_line, null: false
      t.string :secondary_line, null: true
      t.string :street, null: false
      t.string :city, null: false
      t.integer :zip, null: false
    end

    create_table :organizations do |t|
      t.string :name, null: false
      t.text :intro_text
      t.bigint :address_id, null: false
      t.bigint :letter_address_id, null: false
      t.index :address_id, name: 'index_organizations_on_address_id'
      t.index :letter_address_id, name: 'index_organizations_on_letter_address_id'
    end

    create_table :payments do |t|
      t.integer :state, default: 0, null: false
      t.datetime :paid_timestamp, null: true
      t.references :organization, foreign_key: true, null: false
    end

    create_table :organization_holidays do |t|
      t.date :beginning, null: false
      t.date :ending, null: false
      t.string :description, null: false

      t.references :organizations, foreign_key: true, null: false
    end

    create_table :regional_centers do |t|
      t.string :name, null: false
      t.string :short_name, null: false

      t.references :addresses, foreign_key: true, null: false
    end

    create_table :service_specifications do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.integer :work_clothing_expenses, null: false
      t.integer :accommodation_expenses, null: false
      t.json :work_days_expenses, null: false
      t.json :paid_vacation_expenses, null: false
      t.json :first_day_expenses, null: false
      t.json :last_day_expenses, null: false
      t.string :location
      t.boolean :active, default: true
      t.string :identification_number, null: false

      t.references :organizations, foreign_key: true, null: false
      t.index :identification_number, unique: true
    end

    create_table :users do |t|
      t.string :email, null: false
      t.bigint :referencee_id, null: false
      t.string :referencee_type, null: false

      t.index :email, unique: true
      t.index %i[referencee_id referencee_type], unique: true
    end

    create_table :civil_servants do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :zdp, null: false
      t.string :hometown, null: false
      t.date :birthday, null: false
      t.string :phone, null: false
      t.string :iban, null: false
      t.string :health_insurance, null: false

      t.references :regional_centers, foreign_key: true, null: false
      t.references :addresses, foreign_key: true, null: false
      t.index :zdp, unique: true
    end

    create_table :administrators do |t|
      t.references :organizations, foreign_key: true, null: false
    end

    create_table :workshops do |t|
      t.string :name, null: false

      t.index :name, unique: true
    end

    create_table :driving_licenses do |t|
      t.string :name, null: false

      t.index :name, unique: true
    end

    create_join_table :civil_servants, :driving_licenses do |t|
      t.index :civil_servant_id
      t.index :driving_license_id
    end

    create_join_table :civil_servants, :workshops do |t|
      t.index :civil_servant_id
      t.index :workshop_id
    end

    create_join_table :driving_licenses, :service_specifications do |t|
      t.boolean :mandatory, default: false, null: false
      t.index :driving_license_id, name: 'index_driving_licenses_service_spec_on_driving_license_id'
      t.index :service_specification_id, name: 'index_driving_licenses_service_spec_on_service_specification_id'
    end

    create_join_table :workshops, :service_specifications do |t|
      t.boolean :mandatory, default: false, null: false
      t.index :workshop_id, name: 'index_service_spec_workshops_on_service_specification_id'
      t.index :service_specification_id, name: 'index_service_spec_workshops_on_service_spec_id'
    end

    create_table :services do |t|
      t.date :beginning, null: false
      t.date :ending, null: false
      t.date :confirmation_date
      t.integer :service_type, default: 0, null: false
      t.boolean :last_service, default: false, null: false
      t.boolean :feedback_mail_sent, default: false, null: false

      t.references :civil_servants, foreign_key: true, null: false
      t.references :service_specifications, foreign_key: true, null: false
    end

    create_table :expense_sheets do |t|
      t.date :beginning, null: false
      t.date :ending, null: false
      t.integer :work_days, null: false
      t.integer :unpaid_company_holiday_days, default: 0, null: false
      t.integer :paid_company_holiday_days, default: 0, null: false
      t.string :company_holiday_comment
      t.integer :workfree_days, default: 0, null: false
      t.integer :sick_days, default: 0, null: false
      t.string :sick_comment
      t.integer :paid_vacation_days, default: 0, null: false
      t.string :paid_vacation_comment
      t.integer :unpaid_vacation_days, default: 0, null: false
      t.string :unpaid_vacation_comment
      t.integer :driving_expenses, default: 0, null: false
      t.string :driving_expenses_comment
      t.integer :extraordinary_expenses, default: 0, null: false
      t.string :extraordinary_expenses_comment
      t.integer :clothing_expenses, default: 0, null: false
      t.string :clothing_expenses_comment
      t.string :credited_iban, null: false
      t.integer :state, default: 0, null: false
      t.integer :amount, default: 0, null: false

      t.references :services, foreign_key: true, null: false
      t.references :payments, foreign_key: true, null: true
    end

    add_foreign_key :civil_servants_driving_licenses, :civil_servants, column: :civil_servant_id
    add_foreign_key :civil_servants_driving_licenses, :driving_licenses, column: :driving_license_id
    add_foreign_key :civil_servants_workshops, :civil_servants, column: :civil_servant_id
    add_foreign_key :civil_servants_workshops, :workshops, column: :workshop_id
    add_foreign_key :driving_licenses_service_specifications, :service_specifications, column: :service_specification_id
    add_foreign_key :driving_licenses_service_specifications, :driving_licenses, column: :driving_license_id
    add_foreign_key :service_specifications_workshops, :workshops, column: :workshop_id
    add_foreign_key :service_specifications_workshops, :service_specifications, column: :service_specification_id
  end
end
