# frozen_string_literal: true

require_relative '../v1/data_migrator'

namespace :v1_migration do
  desc 'Strips all whitespaces from the IBAN'
  task strip_iban: :environment do
    puts 'Stripping IBANs...'
    User.all.each do |user|
      user.bank_iban = user.bank_iban.gsub(/\s+/, '').upcase
      user.save validate: false
    end
  end

  desc 'Migrates from legacy iZivi data to new data format'
  task :import_legacy_data, [:dump_file] => [:environment] do |_t, args|
    dump_file = args[:dump_file]

    if dump_file.empty?
      puts <<~HELP
        USAGE:
          bin/bundle exec rake v1_migration:import_legacy_data[master-db-dump-file-path]

          Environment variables:
            - DATABASE_USERNAME
            - DATABASE_PASSWORD
            - DATABASE_NAME

        DESCRIPTION:
          Imports dump from master db dump file path and migrates to new db format.
          CAUTION: This operation wipes all data in the currently selected data and replaces it with dump
      HELP

      exit 1
    end

    unless File.exist? dump_file
      puts "Cannot find file #{dump_file}"
      exit 1
    end

    V1::DataMigrator.new(dump_file).migrate
  end
end
