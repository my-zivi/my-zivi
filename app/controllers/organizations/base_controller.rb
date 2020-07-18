# frozen_string_literal: true

module Organizations
  class BaseController < ApplicationController
    before_action :authenticate_user!

    check_authorization

    layout 'organizations/application'

    rescue_from CanCan::AccessDenied do |_exception|
      # TODO: Process 401 by error app
      render plain: I18n.t('not_allowed'), status: :unauthorized
    end
  end
end
