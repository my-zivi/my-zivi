class AddTagsToBlogEntries < ActiveRecord::Migration[6.1]
  def change
    add_column :blog_entries, :tags, :string, array: true, default: %w[article]

    reversible do |dir|
      dir.up do
        change_column_default :blog_entries, :tags, nil
      end
    end
  end
end
