# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def after_accept_path_for(_resource)
      civil_servants_register_path
    end
  end
end
