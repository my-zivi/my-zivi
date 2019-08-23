# frozen_string_literal: true

module Concerns
  module ErrorHandler
    extend ActiveSupport::Concern

    class << self
      # :reek:TooManyStatements
      def included(klass)
        # Caution, do not simplify statement which is suggested by RubyMine. It breaks the application
        klass.rescue_from(ActiveRecord::RecordNotFound) { |error| render_json_error(error) }
        klass.rescue_from(ValidationError) { |error| render_validation_error(error) }
        klass.rescue_from(ArgumentError) { |error| render_validation_error(error) }
        klass.rescue_from(AuthorizationError) { |_error| render_authorization_error }
        klass.rescue_from(ActionController::UnknownFormat) { |_error| render_format_error }
        klass.rescue_from(CalculationError) { |error| render_calculation_error(error) }
        klass.rescue_from(ActiveRecord::ReadOnlyRecord) { |error| render_json_error(error) }
      end
    end

    private

    def render_json_error(error)
      render json: { error: error.message }, status: :not_found
    end

    # :reek:FeatureEnvy
    def render_validation_error(error)
      json = error.is_a?(ArgumentError) ? { errors: [error.message] } : error.to_h
      render json: json, status: :bad_request
    end

    def render_authorization_error
      render json: { error: I18n.t('errors.authorization_error') }, status: :unauthorized
    end

    def render_format_error
      render json: { error: I18n.t('errors.format_error') }, status: :not_acceptable
    end

    def render_calculation_error(error)
      render json: { error: error.message }, status: :bad_request
    end
  end
end
