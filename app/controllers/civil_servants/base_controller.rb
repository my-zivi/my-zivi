# frozen_string_literal: true

module CivilServants
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action -> { authorize! :access, :civil_servant_portal }

    check_authorization

    layout 'civil_servants/application'

    rescue_from CanCan::AccessDenied do |_exception|
      # TODO: Process 401 by error app
      render plain: I18n.t('not_allowed'), status: :unauthorized
    end
  end
end
