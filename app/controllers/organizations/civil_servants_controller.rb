# frozen_string_literal: true

module Organizations
  class CivilServantsController < BaseController
    load_and_authorize_resource

    def index
      @civil_servants = @civil_servants.includes(:services)
    end

    def show; end
  end
end
