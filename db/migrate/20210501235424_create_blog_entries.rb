class CreateBlogEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_entries do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :description, null: false
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
