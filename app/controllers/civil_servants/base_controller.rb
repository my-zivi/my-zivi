# frozen_string_literal: true

module CivilServants
  class BaseController < ApplicationController
    before_action :authenticate_user!

    layout 'civil_servants/application'

    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = I18n.t('not_allowed')
      redirect_to civil_servants_path
    end
  end
end
