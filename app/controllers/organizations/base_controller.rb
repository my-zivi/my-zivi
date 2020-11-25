# frozen_string_literal: true

module Organizations
  class BaseController < ApplicationController
    include ::AuthenticableAndAuthorizable

    before_action -> { authorize! :access, :organization_portal }

    layout 'organizations/application'
  end
end
