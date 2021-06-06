class AdaptJobPostings < ActiveRecord::Migration[6.1]
  def change
    rename_column :job_postings, :minimum_service_length, :minimum_service_months
    remove_column :job_postings, :company

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
  end
end
