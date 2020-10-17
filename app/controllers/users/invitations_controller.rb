# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def after_accept_path_for(_resource)
      new_user_registration_path
    end
  end
end
