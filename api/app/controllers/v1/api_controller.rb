# frozen_string_literal: true

module V1
  class APIController < ApplicationController
    before_action :authenticate_user!

    def authorize_admin!
      raise AuthorizationError unless current_user.admin?
    end
  end
end
