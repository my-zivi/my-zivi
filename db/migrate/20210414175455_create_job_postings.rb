class CreateJobPostings < ActiveRecord::Migration[6.0]
  def change
    create_table :job_postings do |t|
      t.string :title
      t.string :link
      t.text :description
      t.date :publication_date
      t.string :icon_url

      t.timestamps
    end

    add_index :job_postings, :link, unique: true
  end
end
