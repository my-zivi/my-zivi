# frozen_string_literal: true

class RobotsController < ApplicationController
  layout false

  respond_to :txt

  def robots
    if ENV['ROBOTS_ALLOWED'] == 'true'
      render 'robots/allow'
    else
      render 'robots/disallow'
    end
  end
end
