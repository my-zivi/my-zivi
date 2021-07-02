class AddControlFieldsToJobPosting < ActiveRecord::Migration[6.1]
  def change
    add_column :job_postings, :published, :boolean, null: false, default: true
    add_column :job_postings, :relevancy, :integer, null: false, default: 1
    add_column :job_postings, :brief_description, :string
    add_column :job_postings, :featured_as_new, :boolean, null: false, default: false
    add_column :job_postings, :priority_program, :boolean, null: false, default: false

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE job_postings SET brief_description = left(description::varchar, 120);
        SQL
      end
    end

    change_column_null :job_postings, :brief_description, false
  end
end
