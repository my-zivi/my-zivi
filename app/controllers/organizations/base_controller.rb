# frozen_string_literal: true

module Organizations
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action -> { authorize! :access, :organization_portal }

    check_authorization

    layout 'organizations/application'
  end
end
