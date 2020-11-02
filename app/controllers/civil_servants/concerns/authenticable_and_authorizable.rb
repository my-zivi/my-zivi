# frozen_string_literal: true

module CivilServants
  module Concerns
    module AuthenticableAndAuthorizable
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_user!

        check_authorization

        rescue_from CanCan::AccessDenied do |_exception|
          # TODO: Process 401 by error app
          respond_to do |format|
            format.html { render plain: I18n.t('not_allowed'), status: :unauthorized }
            format.json { render json: { error: I18n.t('not_allowed'), status: 401 }, status: :unauthorized }
          end
        end
      end
    end
  end
end
