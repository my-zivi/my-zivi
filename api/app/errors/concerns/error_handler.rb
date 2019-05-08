# frozen_string_literal: true

module Concerns
  module ErrorHandler
    extend ActiveSupport::Concern

    class << self
      def included(klass)
        # Caution, do not simplify statement which is suggested by RubyMine. It breaks the application
        klass.rescue_from(ActiveRecord::RecordNotFound) { |error| render_json_error(error) }
        klass.rescue_from(ValidationError) { |error| render_validation_error(error) }
      end
    end

    private

    def render_json_error(error)
      render json: { status: 'error', error: error.message }, status: :not_found
    end

    def render_validation_error(error)
      render json: { status: 'error', errors: error.validation_errors }, status: :bad_request
    end
  end
end
