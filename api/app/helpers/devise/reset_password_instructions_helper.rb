# frozen_string_literal: true

module Devise
  module ResetPasswordInstructionsHelper
    def reset_link(user, token)
      link = format(ENV.fetch('PASSWORD_RESET_LINK', ''), token: token)
      link.presence || edit_user_password_url(user, reset_password_token: token)
    end
  end
end
