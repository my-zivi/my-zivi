# frozen_string_literal: true

module Organizations
  class BaseController < ApplicationController
    before_action :authenticate_user!

    layout 'organizations/application'

    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = I18n.t('not_allowed')
      redirect_to organizations_path
    end
  end
end
