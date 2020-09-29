# frozen_string_literal: true

module Organizations
  class CivilServantsController < BaseController
    load_and_authorize_resource

    include UsersHelper

    def index
      load_filters
      @civil_servants = filtered_civil_servants
    end

    def show
      load_filters
      @services = Service
                  .accessible_by(current_ability)
                  .definitive
                  .where(civil_servant_id: @civil_servant.id)
                  .includes(:service_specification)
    end

    private

    def filtered_civil_servants
      service_filter = @filters[:show_inactive] ? {} : { services: Service.active }

      CivilServant
        .accessible_by(current_ability)
        .eager_load(:services)
        .where(service_filter)
        .distinct
        .includes(services: :service_specification)
        .order('"services"."beginning" DESC')
    end

    def load_filters
      @filters = {
        show_inactive: params.dig(:filters, :show_inactive) == 'true'
      }
    end
  end
end
