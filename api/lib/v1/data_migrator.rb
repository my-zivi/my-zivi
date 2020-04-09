# frozen_string_literal: true

require 'fileutils'

module V1
  class DataMigrator
    MIGRATION_DATABASE_NAME = 'myzivi_migration'
    RAILS_DATABASE_NAME = Rails.configuration.database_configuration[Rails.env]['database'].freeze

    def initialize(dump_file)
      @dump_file = dump_file

      @username = safe_env_fetch('DATABASE_USERNAME')
      @password = safe_env_fetch('DATABASE_PASSWORD')
    end

    # :reek:UncommunicativeVariableName
    def migrate
      create_migration_db
      load_old_data
      migrate_old_data
      prepare_new_database
      copy_migrated_data
    rescue StandardError => e
      warn e.message
    ensure
      remove_migration_database
    end

    private

    def create_migration_db
      puts 'Creating migration database'
      execute_sql <<-SQL.chomp
        CREATE DATABASE #{MIGRATION_DATABASE_NAME};
      SQL
    end

    def load_old_data
      puts 'Loading old data'
      system! "#{mysql_command(MIGRATION_DATABASE_NAME)} < #{@dump_file}"
    end

    def migrate_old_data
      puts 'Migrating old data to new format'
      system! "#{mysql_command(MIGRATION_DATABASE_NAME)} < #{Rails.root.join('migration', 'v1.sql')}"
    end

    def prepare_new_database
      puts 'Preparing new database'
      FileUtils.chdir Rails.root.to_s do
        system! 'bin/rails db:drop db:create db:schema:load'
      end
    end

    def copy_migrated_data
      puts 'Copying migrated data'

      Dir.mktmpdir('myzivi_dump') do |tempdir|
        output_file = "#{tempdir}/outfile.sql"

        system! <<~SHELL
          mysqldump \
            --no-create-info \
            --complete-insert #{MIGRATION_DATABASE_NAME} > #{output_file} -u#{@username} -p#{@password}
        SHELL

        system! "#{mysql_command(RAILS_DATABASE_NAME)} < #{output_file}"
      end
    end

    def remove_migration_database
      puts 'Removing migration databse'
      execute_sql <<-SQL.chomp
        DROP DATABASE #{MIGRATION_DATABASE_NAME};
      SQL
    end

    def safe_env_fetch(key)
      value = ENV[key]
      abort "Environment variable #{key} could not be found but is required" if value.nil?

      value
    end

    def mysql_command(database_name = nil)
      base = "mysql -u#{@username} -p#{@password}"
      base += " -D#{database_name}" if database_name

      base
    end

    def execute_sql(sql)
      system! "#{mysql_command} <<< \"#{sql}\""
    end

    def system!(*args)
      raise "Command #{args} failed" unless system(*args)
    end
  end
end
