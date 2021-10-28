# frozen_string_literal: true

module Organizations
  class ServiceAgreementsController < BaseController
    PERMITTED_PARAMS = [
      :beginning, :ending, :service_specification_id, :service_type, :last_service,
      { civil_servant_attributes: [:id, :first_name, :last_name, { user_attributes: %i[id email] }] }
    ].freeze

    authorize_resource :service
    breadcrumb 'organizations.service_agreements.index', :organizations_service_agreements_path

    before_action :load_civil_servant, only: %i[new create]
    before_action :load_service_specifications, only: %i[new create]

    def index
      @service_agreements = Service.accessible_by(current_ability).agreement
    end

    def destroy
      service = Service.find(params[:id])
      authorize! :destroy, service
      if service.destroy
        flash.now[:notice] = t('.successful_destroy')
      else
        flash.now[:error] = t('.erroneous_destroy')
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
      new_breadcrumb
      @service_agreement = Service.new(civil_servant: @civil_servant)
    end

    def create
      new_breadcrumb
      agreement_creator = ServiceAgreementCreator.new(@civil_servant, current_organization_admin)
      if agreement_creator.call(service_agreement_params)
        redirect_to organizations_service_agreements_path, notice: t('.successful_create')
      else
        @service_agreement = agreement_creator.service_agreement
        flash.now[:error] = t('.erroneous_create')
        render :new
      end
    end

    private

    def load_civil_servant
      @civil_servant = find_civil_servant_by_email || CivilServant.new(user: User.new)
    end

    def find_civil_servant_by_email
      CivilServant.joins(:user).find_by(
        users: {
          email: service_agreement_params.dig(:civil_servant_attributes, :user_attributes, :email)
        }
      )
    end

    def load_service_specifications
      @service_specifications = current_organization.service_specifications
    end

    def service_agreement_params
      params.require(:service_agreement).permit(*PERMITTED_PARAMS)
    end

    def new_breadcrumb
      breadcrumb 'organizations.service_agreements.new', :new_organizations_service_agreement_path
    end
  end
end
