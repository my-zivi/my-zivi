# frozen_string_literal: true

module CivilServants
  class ServicesController < BaseController
    load_and_authorize_resource

    def index
      load_filters
      @services = filtered_service.chronologically.includes(:service_specification, :organization)
    end

    def show; end

    private

    def filtered_service
      return @services if @filters[:show_all]

      @services.where('ending >= ?', Time.zone.today)
    end

    def load_filters
      @filters = {
        show_all: params.dig(:filters, :show_all) == 'true'
      }
    end
  end
end
