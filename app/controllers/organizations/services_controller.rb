# frozen_string_literal: true

module Organizations
  class ServicesController < BaseController
    load_and_authorize_resource

    def index
      respond_to do |format|
        format.html
        format.json { render json: ServicesSerializer.call(services) }
      end
    end

    def show; end

    def edit; end

    private

    def services
      Service
        .accessible_by(current_ability)
        .overlapping_date_range(filter_params[:beginning], filter_params[:ending])
        .joins(:civil_servant)
    end

    def filter_params
      {
        beginning: parse_filter_param(params.dig(:filter, :beginning)) || 1.month.ago.at_beginning_of_month,
        ending: parse_filter_param(params.dig(:filter, :ending)) || 1.month.from_now.at_end_of_month
      }
    end

    # :reek:UtilityFunction
    def parse_filter_param(param)
      Date.parse(param) if param
    end
  end
end
