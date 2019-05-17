# frozen_string_literal: true

module V1
  class ServiceSpecificationsController < APIController
    before_action :set_service_specification, only: %i[update]

    PERMITTED_SERVICE_SPECIFICATION_KEYS = %i[
      name short_name working_clothes_expenses
      accommodation_expenses location active
    ].freeze

    PERMITTED_SERVICE_SPECIFICATION_JSON_KEYS = {
      work_days_expenses: %i[breakfast lunch dinner],
      paid_vacation_expenses: %i[breakfast lunch dinner],
      first_day_expenses: %i[breakfast lunch dinner],
      last_day_expenses: %i[breakfast lunch dinner]
    }.freeze

    def index
      @service_specifications = ServiceSpecification.all
    end

    # TODO: admin protect create, update

    def create
      @service_specification = ServiceSpecification.new(service_specification_params)

      raise ValidationError, @service_specification.errors unless @service_specification.save

      render_show
    end

    def update
      raise ValidationError, @service_specification.errors unless
          @service_specification.update(service_specification_params)

      render_show
    end

    private

    def set_service_specification
      @service_specification = ServiceSpecification.find(params[:id])
    end

    def render_show
      render :show
    end

    def service_specification_params
      sanitized_params = params
                         .require(:service_specification)
                         .permit(*PERMITTED_SERVICE_SPECIFICATION_KEYS, PERMITTED_SERVICE_SPECIFICATION_JSON_KEYS)
                         .to_h

      sanitized_params.map do |key, value|
        is_json_key = PERMITTED_SERVICE_SPECIFICATION_JSON_KEYS.as_json.key? key
        value = is_json_key ? json_string_to_integer(value) : value

        [key, value]
      end.to_h
    end

    def json_string_to_integer(json)
      json.map do |json_key, json_value|
        [json_key.to_sym, json_value.to_i]
      end.to_h
    end
  end
end
