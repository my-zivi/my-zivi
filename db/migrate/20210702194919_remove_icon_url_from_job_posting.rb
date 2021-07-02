class RemoveIconUrlFromJobPosting < ActiveRecord::Migration[6.1]
  def change
    remove_column :job_postings, :icon_url, :string
  end
end
