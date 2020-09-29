# frozen_string_literal: true

module Organizations
  class ServiceAgreementsController < BaseController
    authorize_resource :service

    include UsersHelper

    def index
      @service_agreements = Service.accessible_by(current_ability).agreement
    end

    def destroy
      service = Service.find(params[:id])
      authorize! :destroy, service
      if service.destroy
        flash[:notice] = t('.successful_destroy')
      else
        flash[:error] = t('.erroneous_destroy')
      end

      redirect_back fallback_location: organizations_service_agreements_path
    end
  end
end
