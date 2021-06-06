class AdaptJobPostings < ActiveRecord::Migration[6.1]
  def change
    rename_column :job_postings, :minimum_service_length, :minimum_service_months
    rename_column :available_service_periods, :job_postings_id, :job_posting_id

    reversible do |dir|
      dir.up do
        change_column :job_postings, :minimum_service_months, :integer, using: 1
        change_column :job_postings, :identification_number, :integer, using: 'identification_number::integer'
        remove_index :job_postings, :link
      end

      dir.down do
        change_column :job_postings, :minimum_service_months, :string, using: "'1 Monat(e)'"
        change_column :job_postings, :identification_number, :string, using: 'identification_number::varchar'
        add_index :job_postings, :link, unique: true
      end
    end

    remove_column :job_postings, :link, :string
    remove_column :job_postings, :company, :string

    create_table :job_posting_api_poll_logs do |t|
      t.jsonb :log, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
