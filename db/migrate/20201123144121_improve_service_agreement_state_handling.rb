class ImproveServiceAgreementStateHandling < ActiveRecord::Migration[6.0]
  def change
    rename_column :services, :civil_servant_agreed_on, :civil_servant_decided_at
    rename_column :services, :organization_agreed_on, :organization_decided_at

    change_column_null :services, :civil_servant_decided_at, true
    change_column_null :services, :organization_decided_at, true

    change_column_null :services, :civil_servant_agreed, true
    change_column_default :services, :civil_servant_agreed, from: false, to: nil
    change_column_null :services, :organization_agreed, true
    change_column_default :services, :organization_agreed, from: false, to: nil

    reversible do |direction|
      direction.up do
        execute <<~SQL
          CREATE OR REPLACE FUNCTION civil_servant_agreed_changed() RETURNS TRIGGER AS $$
            BEGIN
              UPDATE services SET civil_servant_decided_at = NOW()
                WHERE id = NEW.id;
              RETURN NULL;
            END;
          $$ LANGUAGE plpgsql;

          CREATE OR REPLACE FUNCTION organization_agreed_changed() RETURNS TRIGGER AS $$
            BEGIN
              UPDATE services SET organization_decided_at = NOW()
                WHERE id = NEW.id;
              RETURN NULL;
            END;
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER civil_servant_agreed_update_trigger
            AFTER UPDATE ON services
            FOR EACH ROW
            WHEN ( OLD.civil_servant_agreed IS DISTINCT FROM NEW.civil_servant_agreed )
            EXECUTE FUNCTION civil_servant_agreed_changed();

          CREATE TRIGGER civil_servant_agreed_insert_trigger
            AFTER INSERT ON services
            FOR EACH ROW
            WHEN ( NEW.civil_servant_agreed IS NOT NULL )
            EXECUTE FUNCTION civil_servant_agreed_changed();

          CREATE TRIGGER organization_agreed_update_trigger
            AFTER UPDATE ON services
            FOR EACH ROW
            WHEN ( OLD.organization_agreed IS DISTINCT FROM NEW.organization_agreed )
            EXECUTE FUNCTION organization_agreed_changed();

          CREATE TRIGGER organization_agreed_insert_trigger
            AFTER INSERT ON services
            FOR EACH ROW
            WHEN ( NEW.organization_agreed IS NOT NULL )
            EXECUTE FUNCTION organization_agreed_changed();
        SQL
      end

      direction.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS civil_servant_agreed_update_trigger ON services;
          DROP TRIGGER IF EXISTS civil_servant_agreed_insert_trigger ON services;
          DROP FUNCTION IF EXISTS civil_servant_agreed_changed;

          DROP TRIGGER IF EXISTS organization_agreed_update_trigger ON services;
          DROP TRIGGER IF EXISTS organization_agreed_insert_trigger ON services;
          DROP FUNCTION IF EXISTS organization_agreed_changed;
        SQL
      end
    end

  end
end
