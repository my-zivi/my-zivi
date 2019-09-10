# frozen_string_literal: true

# Legacy password authentication was extracted to concern so that if it is no longer needed,
# the file can just be deleted and the method removed from user.rb

require 'bcrypt'

module Concerns
  module LegacyPasswordAuthenticatable
    def valid_legacy_password?(plain_password)
      password = ::BCrypt::Engine.hash_secret(plain_password, ::BCrypt::Password.new(legacy_password).salt)

      if Devise.secure_compare(password, legacy_password)
        migrate_legacy_password(plain_password)
        return true
      end

      false
    end

    def reset_legacy_password
      self.legacy_password = nil if legacy_password.present?
    end

    private

    def migrate_legacy_password(plain_password)
      self.password = plain_password
      self.legacy_password = nil

      # If a user has an invalid field, like an invalid IBAN, saving would fail if we didn't skip validation
      save validate: false
    end
  end
end
