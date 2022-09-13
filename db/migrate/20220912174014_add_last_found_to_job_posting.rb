class AddLastFoundToJobPosting < ActiveRecord::Migration[6.1]
  def change
    add_column :job_postings, :last_found_at, :date, null: false, default: '1970-01-01'
    change_column_default :job_postings, :last_found_at, nil
  end
end
