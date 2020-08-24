# frozen_string_literal: true

module Organizations
  class CivilServantsController < BaseController
    load_and_authorize_resource

    def index
      load_filters
      @civil_servants = filtered_civil_servants
    end

    def show; end

    private

    def filtered_civil_servants
      service_scope = Service.accessible_by(current_ability)
      service_scope = service_scope.active unless @filters[:show_inactive]

      CivilServant
        .eager_load(:services)
        .where(id: service_scope.select(:civil_servant_id))
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
