class AddMissingFieldsToJobPosting < ActiveRecord::Migration[6.1]
  REQUIRED_FIELDS = %i[
    canton
    identification_number
    category
    language
    minimum_service_length
    contact_information
  ].freeze

  def change
    create_table :available_service_periods do |t|
      t.date :beginning, null: false
      t.date :ending, null: false
      t.references :job_postings, null: false, foreign_key: true
      t.timestamps
    end

    create_table :job_posting_workshops do |t|
      t.belongs_to :workshop, null: false, foreign_key: true
      t.belongs_to :job_posting, null: false, foreign_key: true
      t.timestamps
    end

    change_table :job_postings, bulk: true do |t|
      t.text :required_skills
      t.text :preferred_skills
      t.string :canton, default: 'Zürich'
      t.integer :identification_number
      t.string :category, default: 'nature_conservancy'
      t.string :sub_category
      t.string :language, default: 'de'
      t.string :organization_name, default: 'MyZivi'
      t.string :minimum_service_length, default: '1 Monat(e)'
      t.text :contact_information, default: <<~TEXT.squish
        Dieser Betrieb ist noch nicht bei MyZivi registriert.
        Bitte bewerbe Dich im EZIVI.
      TEXT
      t.references :organizations, foreign_key: true, null: true
      t.belongs_to :address, foreign_key: true, null: true
    end

    add_index :job_postings, :identification_number, unique: true

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE job_postings SET identification_number = id
        SQL

        REQUIRED_FIELDS.each do |required_attribute|
          change_column_default :job_postings, required_attribute, nil
          change_column_null :job_postings, required_attribute, false
        end
      end
    end
  end
end
