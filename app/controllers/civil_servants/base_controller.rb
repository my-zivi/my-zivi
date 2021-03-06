# frozen_string_literal: true

module CivilServants
  class BaseController < ApplicationController
    include ::AuthenticableAndAuthorizable

    before_action -> { authorize! :access, :civil_servant_portal }

    layout 'civil_servants/application'
  end
end
