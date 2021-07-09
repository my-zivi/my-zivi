class AddSlugToJobPosting < ActiveRecord::Migration[6.1]
  def up
    add_column :job_postings, :slug, :string

    JobPosting.find_in_batches do |job_postings|
      update_attributes = job_postings.index_by(&:id).transform_values do |posting|
        { slug: posting.default_slug }
      end

      JobPosting.update(update_attributes.keys, update_attributes.values)
    end

    change_column_null :job_postings, :slug, false
    add_index :job_postings, :slug, unique: true
  end

  def down
    remove_column :job_postings, :slug
    remove_index :job_postings, :slug
  end
end
