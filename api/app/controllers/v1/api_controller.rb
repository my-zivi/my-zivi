# frozen_string_literal: true

module V1
  class APIController < ApplicationController
    before_action :authenticate_user!
  end
end
