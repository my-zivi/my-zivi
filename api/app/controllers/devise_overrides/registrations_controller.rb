# frozen_string_literal: true

module DeviseOverrides
  class RegistrationsController < Devise::RegistrationsController
    def create
      raise invalid_community_password_error unless valid_community_password?

      super
    end

    private

    # :reek:UtilityFunction
    def invalid_community_password_error
      full_message = I18n.t('registrations.errors.community_password.not_valid.full')
      single_message = I18n.t('registrations.errors.community_password.not_valid.single')

      ValidationError.new({ community_password: single_message }, [full_message])
    end

    def valid_community_password?
      community_password == ENV['COMMUNITY_PASSWORD']
    end

    def community_password
      params.require(:user).permit(:community_password)[:community_password]
    end
  end
end
