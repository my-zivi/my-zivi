# frozen_string_literal: true

module Concerns
  module ErrorHandler
    extend ActiveSupport::Concern

    class << self
      def included(klass)
        # Caution, do not simplify statement which is suggested by RubyMine. It breaks the application
        klass.rescue_from(ActiveRecord::RecordNotFound) { |error| render_json_error(error) }
        klass.rescue_from(ValidationError) { |error| render_validation_error(error) }
        klass.rescue_from(ArgumentError) { |error| render_validation_error(error) }
        klass.rescue_from(AuthorizationError) { |_error| render_authorization_error }
        klass.rescue_from(CalculationError) { |error| render_calculation_error(error) }
      end
    end

    private

    def render_json_error(error)
      render json: { error: error.message }, status: :not_found
    end

    # :reek:FeatureEnvy
    def render_validation_error(error)
      json = { errors: (error.is_a?(ArgumentError) ? [error.message] : error.validation_errors) }
      render json: json, status: :bad_request
    end

    def render_authorization_error
      render json: { error: I18n.t('errors.authorization_error') }, status: :unauthorized
    end

    def render_calculation_error(error)
      render json: { error: error.message }, status: :bad_request
    end
  end
end
