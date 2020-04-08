# frozen_string_literal: true

module Concerns
  module DeviseUserParamsRegistrable
    extend ActiveSupport::Concern

    included do
      before_action :configure_permitted_parameters, if: :devise_controller?
    end

    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up)
    end
  end
end
