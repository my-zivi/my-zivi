class AddSlugToBlogEntry < ActiveRecord::Migration[6.1]
  def up
    add_column :blog_entries, :slug, :string

    execute <<~SQL.squish.freeze
      UPDATE blog_entries SET slug = LOWER(REPLACE(title, ' ', '-'))
    SQL

    add_index :blog_entries, :slug, unique: true
    change_column_null :blog_entries, :slug, false
  end

  def down
    remove_column :blog_entries, :slug
  end
end
