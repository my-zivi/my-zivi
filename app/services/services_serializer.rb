# frozen_string_literal: true

class ServicesSerializer
  class << self
    def call(services)
      transformed_data = services.map(&method(:extract_service_attributes))

      JSON.dump(transformed_data)
    end

    private

    def extract_service_attributes(service)
      service.slice(:beginning, :ending).merge(
        'civilServant' => extract_civil_servant_attributes(service)
      )
    end

    def extract_civil_servant_attributes(service)
      service
        .civil_servant
        .slice(:id, :full_name)
        .transform_keys { |key| key.camelize(:lower) }
    end
  end
end