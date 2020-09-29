# frozen_string_literal: true

module Organizations
  class ServicesController < BaseController
    load_and_authorize_resource

    include UsersHelper

    def show; end
  end
end
