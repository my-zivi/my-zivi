# frozen_string_literal: true

module CivilServants
  class ServiceAgreementsController < BaseController
    authorize_resource :service, only: :index

    include UsersHelper

    def index
      @service_agreements = Service.includes(:organization, :service_specification)
                              .accessible_by(current_ability).agreement
    end

    def accept
      service = Service.find(params[:service_agreement_id])
      authorize! :accept, service
      if service.update(civil_servant_agreed: true)
        flash[:notice] = t('.successful_accept')
      else
        flash[:error] = t('.erroneous_accept')
      end
      redirect_to civil_servants_service_agreements_path
    end

    def decline
      service = Service.find(params[:service_agreement_id])
      authorize! :decline, service
      if service.update(civil_servant_agreed: false)
        flash[:notice] = t('.successful_decline')
      else
        flash[:error] = t('.erroneous_decline')
      end
      redirect_to civil_servants_service_agreements_path
    end
  end
end
