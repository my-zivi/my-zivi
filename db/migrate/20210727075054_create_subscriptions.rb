class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :organization
      t.string :type, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
          INSERT INTO subscriptions (organization_id, type, created_at, updated_at)
          SELECT id                     AS "organization_id",
                 'Subscriptions::Admin' AS "type",
                 NOW()                  AS "created_at",
                 NOW()                  AS "updated_at"
          FROM organizations;
        SQL
      end
    end
  end
end
