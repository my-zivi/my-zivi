# frozen_string_literal: true

namespace :v1_migration do
  desc 'Strips all whitespaces from the IBAN'
  task strip_iban: :environment do
    puts 'Stripping IBANs...'
    User.all.each do |user|
      user.bank_iban = user.bank_iban.gsub(/\s+/, '')
      user.save validate: false
    end
  end
end
