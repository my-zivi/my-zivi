# frozen_string_literal: true

module V1
  class APIController < ApplicationController
    include AdminAuthorizable

    before_action :authenticate_user!
  end
end
