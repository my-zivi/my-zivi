# frozen_string_literal: true

module CivilServants
  class ServiceAgreementsController < BaseController
    authorize_resource :service, only: :index

    def index
      @service_agreements = Service.includes(:organization, :service_specification)
                                   .accessible_by(current_ability).agreement
    end

    def accept
      service = Service.find(params[:service_agreement_id])
      authorize! :accept, service
      if service.update(civil_servant_agreed: true)
        flash.now[:notice] = t('.successful_accept')
      else
        flash.now[:error] = format_errors(t('.erroneous_accept'), service)
      end
      redirect_to civil_servants_service_agreements_path
    end

    def decline
      service = Service.find(params[:service_agreement_id])
      authorize! :decline, service
      if service.update(civil_servant_agreed: false)
        flash.now[:notice] = t('.successful_decline')
      else
        flash.now[:error] = format_errors(t('.erroneous_decline'), service)
      end
      redirect_to civil_servants_service_agreements_path
    end

    private

    # :reek:UtilityFunction
    def format_errors(error_header, service)
      error_header + service.errors.full_messages.to_sentence
    end
  end
end
