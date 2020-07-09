# frozen_string_literal: true

module Organizations
  class BaseController < ApplicationController
    before_action :authenticate_user!

    layout 'organizations/application'
  end
end
