# frozen_string_literal: true

module Organizations
  class CivilServantsController < BaseController
    load_and_authorize_resource

    def index
      load_filters
      @civil_servants = filtered_civil_servants.includes(:services)
    end

    def show; end

    private

    def filtered_civil_servants
      return @civil_servants if @filters[:show_inactive]

      CivilServant
        .joins(:services)
        .where(id: Service.accessible_by(current_ability).active.select(:civil_servant_id))
        .distinct
    end

    def load_filters
      @filters = {
        show_inactive: params.dig(:filters, :show_inactive) == 'true'
      }
    end
  end
end
