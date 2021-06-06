class AdaptJobPostings < ActiveRecord::Migration[6.1]
  def change
    rename_column :job_postings, :minimum_service_length, :minimum_service_months

    reversible do |dir|
      dir.up do
        change_column :job_postings, :minimum_service_months, :integer, using: 1
        change_column :job_postings, :identification_number, :integer, using: 'identification_number::integer'
      end

      dir.down do
        change_column :job_postings, :minimum_service_months, :string, using: "'1 Monat(e)'"
        change_column :job_postings, :identification_number, :string, using: 'identification_number::varchar'
      end
    end

    create_table :job_posting_free_service_periods do |t|
      t.date :beginning
      t.date :ending
      t.references :job_postings, foreign_key: true, null: false
      t.timestamps
    end
  end
end
