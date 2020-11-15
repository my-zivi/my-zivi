# frozen_string_literal: true

module Organizations
  class ServiceAgreementsController < BaseController
    PERMITTED_PARAMS = [
      :beginning, :ending, :service_specification_id, :service_type, :last_service,
      { civil_servant_attributes: [:id, :first_name, :last_name, { user_attributes: %i[id email] }] }
    ].freeze

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

    def search
      respond_to do |format|
        format.json do
          all_civil_servants = CivilServantServiceAgreementSearch.filtered_all_civil_servants(params[:term])
          organization_civil_servants = CivilServantServiceAgreementSearch
                                        .filtered_organization_civil_servants(params[:term], current_organization)
          render json: { results: CivilServantSelect2Options.call(all_civil_servants, organization_civil_servants) }
        end
      end
    end

    def new
      @service_agreement = agreement_creator.service_agreement
      service_specifications
    end

    def create
      service_specifications
      if agreement_creator.call(service_agreement_params)
        redirect_to organizations_service_agreements_path, notice: t('.successful_create')
      else
        @service_agreement = agreement_creator.service_agreement
        flash[:error] = t('.erroneous_create')
        render :new
      end
    end

    private

    def agreement_creator
      @agreement_creator ||= ServiceAgreementCreator.new(current_organization_admin, service_agreement_params)
    end

    def service_specifications
      @service_specifications ||= current_organization.service_specifications
    end

    def service_agreement_params
      params.require(:service_agreement).permit(*PERMITTED_PARAMS)
    end
  end
end
