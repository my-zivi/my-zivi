class AddSlugToBlogEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :blog_entries, :slug, :string

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish.freeze
          UPDATE blog_entries SET slug = LOWER(REPLACE(title, ' ', '-'))
        SQL
      end
      dir.down {}
    end

    add_index :blog_entries, :slug, unique: true
    change_column_null :blog_entries, :slug, false
  end
end
