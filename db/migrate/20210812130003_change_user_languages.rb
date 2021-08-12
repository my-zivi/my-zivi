class ChangeUserLanguages < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      UPDATE users SET language = 'fr-CH' WHERE language = 'fr';
      UPDATE users SET language = 'de-CH' WHERE language = 'de';
      UPDATE users SET language = 'it-CH' WHERE language = 'it';
    SQL
  end

  def down
    execute <<~SQL
      UPDATE users SET language = 'fr' WHERE language = 'fr-CH';
      UPDATE users SET language = 'de' WHERE language = 'de-CH';
      UPDATE users SET language = 'it' WHERE language = 'it-CH';
    SQL
  end
end
