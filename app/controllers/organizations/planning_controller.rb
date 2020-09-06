# frozen_string_literal: true

module Organizations
  class PlanningController < BaseController
    def index
      respond_to do |format|
        format.html
        format.json { render json: serialize_services }
      end
    end

    private

    def serialize_services
      transformed_data = grouped_services.map do |civil_servant, services|
        {
          'fullName' => civil_servant.full_name,
          'services' => services.map { |service| service.slice(:beginning, :ending) }
        }
      end

      JSON.dump(transformed_data)
    end

    def grouped_services
      Service
        .accessible_by(current_ability)
        .overlapping_date_range(filter_params[:beginning], filter_params[:ending])
        .joins(:civil_servant)
        .group_by(&:civil_servant)
    end

    def filter_params
      {
        beginning: parse_filter_param(params.dig(:filter, :beginning)) || 1.month.ago.at_beginning_of_month,
        ending: parse_filter_param(params.dig(:filter, :ending)) || 1.month.from_now.at_end_of_month
      }
    end

    def parse_filter_param(param)
      Date.parse(param) if param
    end
  end
end
