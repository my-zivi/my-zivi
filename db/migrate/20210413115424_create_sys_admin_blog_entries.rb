class CreateSysAdminBlogEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_entries do |t|
      t.string :title, null: false
      t.string :author, null: false

      t.timestamps
    end
  end
end
