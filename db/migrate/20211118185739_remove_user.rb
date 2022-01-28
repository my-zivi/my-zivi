class RemoveUser < ActiveRecord::Migration[6.1]
  def up
    add_column :civil_servants, :language, :string, default: 'de', null: false
    add_column :organization_members, :language, :string, default: 'de', null: false

    migrate_civil_servants
    migrate_organization_members

    drop_table :users
    remove_column :organization_members, :contact_email

    add_index :organization_members, :email, unique: true
    add_index :civil_servants, :email, unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def migrate_civil_servants
    execute(<<~SQL.freeze)
      UPDATE civil_servants
      SET confirmation_sent_at=users.confirmation_sent_at,
          confirmation_token=users.confirmation_token,
          confirmed_at=users.confirmed_at,
          current_sign_in_at=users.current_sign_in_at,
          current_sign_in_ip=users.current_sign_in_ip,
          email=users.email,
          encrypted_password=users.encrypted_password,
          failed_attempts=users.failed_attempts,
          invitation_accepted_at=users.invitation_accepted_at,
          invitation_created_at=users.invitation_created_at,
          invitation_limit=users.invitation_limit,
          invitation_sent_at=users.invitation_sent_at,
          invitation_token=users.invitation_token,
          invitations_count=users.invitations_count,
          invited_by_id=users.invited_by_id,
          invited_by_type=users.invited_by_type,
          language=users.language,
          last_sign_in_at=users.last_sign_in_at,
          last_sign_in_ip=users.last_sign_in_ip,
          locked_at=users.locked_at,
          remember_created_at=users.remember_created_at,
          reset_password_sent_at=users.reset_password_sent_at,
          reset_password_token=users.reset_password_token,
          sign_in_count=users.sign_in_count,
          unconfirmed_email=users.unconfirmed_email,
          unlock_token=users.unlock_token
      FROM users
      WHERE users.referencee_id = civil_servants.id
        AND users.referencee_type = 'CivilServant';
    SQL
  end

  def migrate_organization_members
    execute('UPDATE organization_members SET email=COALESCE(contact_email, \'\')')

    execute(<<~SQL.freeze)
      UPDATE organization_members
      SET confirmation_sent_at=users.confirmation_sent_at,
          confirmation_token=users.confirmation_token,
          confirmed_at=users.confirmed_at,
          current_sign_in_at=users.current_sign_in_at,
          current_sign_in_ip=users.current_sign_in_ip,
          email=users.email,
          encrypted_password=users.encrypted_password,
          failed_attempts=users.failed_attempts,
          invitation_accepted_at=users.invitation_accepted_at,
          invitation_created_at=users.invitation_created_at,
          invitation_limit=users.invitation_limit,
          invitation_sent_at=users.invitation_sent_at,
          invitation_token=users.invitation_token,
          invitations_count=users.invitations_count,
          invited_by_id=users.invited_by_id,
          invited_by_type=users.invited_by_type,
          language=users.language,
          last_sign_in_at=users.last_sign_in_at,
          last_sign_in_ip=users.last_sign_in_ip,
          locked_at=users.locked_at,
          remember_created_at=users.remember_created_at,
          reset_password_sent_at=users.reset_password_sent_at,
          reset_password_token=users.reset_password_token,
          sign_in_count=users.sign_in_count,
          unconfirmed_email=users.unconfirmed_email,
          unlock_token=users.unlock_token
      FROM users
      WHERE users.referencee_id = organization_members.id
        AND users.referencee_type = 'OrganizationMember';
    SQL
  end
end
