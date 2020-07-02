# frozen_string_literal: true

module CivilServants
  class Base < ApplicationController
    before_action :authenticate_user!

    layout 'civil_servants/application'
  end
end
