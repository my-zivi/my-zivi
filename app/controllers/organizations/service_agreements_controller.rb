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
      pp params
      pp params[:term]
      respond_to do |format|
        format.json { render json: { results: CivilServantSearch.call(params[:term], current_organization) } }
      end
    end

    def new
      @service_agreement = Service.new(civil_servant: civil_servant)
      load_service_specifications
    end

    def create
      load_service_specifications
      if create_service_agreement
        redirect_to organizations_service_agreements_path, notice: t('.successful_create')
      else
        debugger
        flash[:error] = t('.erroneous_create')
        render :new
      end
    end

    private

    def load_service_specifications
      @service_specifications ||= current_organization.service_specifications
    end

    def create_service_agreement
      Service.transaction do
        @service_agreement = Service.new(modify_service_agreement_params)
        @service_agreement.civil_servant.user.invite! if @service_agreement.civil_servant.user.new_record?
        @service_agreement.save
      end
    end

    def modify_service_agreement_params
      service_agreement_params.merge(organization_agreed: true, civil_servant: civil_servant)
    end

    def civil_servant
      @civil_servant ||= find_civil_servant_by_email || CivilServant.new(user: User.new)
    end

    def find_civil_servant_by_email
      CivilServant.joins(:user).find_by(
        users: {
          email: service_agreement_params.dig(:civil_servant_attributes, :user_attributes, :email)
        }
      )
    end

    def build_civil_servant
      CivilServant.new(user: User.new)
    end

    def service_agreement_params
      params.require(:service_agreement).permit(*PERMITTED_PARAMS)
    end
  end
end
