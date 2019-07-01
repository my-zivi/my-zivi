# frozen_string_literal: true

module V1
  class ServiceCalculatorController < APIController
    def calculate_service_days
      ending = Date.parse(service_calculator_params[:ending])
      service_days = service_calculator.calculate_chargeable_service_days(ending)
      render json: { result: service_days }
    end

    def calculate_ending
      service_days = service_calculator_params[:service_days].to_i
      ending = service_calculator.calculate_ending_date(service_days)
      render json: { result: ending }
    end

    private

    def service_calculator
      @service_calculator ||= ServiceCalculator.new(Date.parse(service_calculator_params[:beginning]))
    end

    def service_calculator_params
      params.permit(:beginning, :ending, :service_days)
    end
  end
end
