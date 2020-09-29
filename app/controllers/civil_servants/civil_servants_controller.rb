# frozen_string_literal: true

module CivilServants
  class CivilServantsController < BaseController
    PERMITTED_CIVIL_SERVANT_PARAMS = [
      :zdp, :first_name, :last_name, :hometown, :birthday,
      :phone, :iban, :health_insurance, :regional_center_id,
      { workshop_ids: [], driving_license_ids: [],
        user_attributes: %i[email language id],
        address_attributes: %i[
          primary_line secondary_line street
          supplement city zip
        ] }
    ].freeze

    PERMITTED_FORM_PARTIALS = %w[
      personal_information_form address_information_form
      login_information_form bank_and_insurance_information_form service_specific_information_form
    ].freeze

    before_action :set_civil_servant, only: %i[edit update]
    before_action -> { authorize! params[:action].to_sym, @civil_servant }

    include UsersHelper

    def edit; end

    def update
      if @civil_servant.update(civil_servant_params)
        flash[:success] = t('.successfully_updated')
        redirect_to edit_civil_servants_civil_servant_path
      else
        respond_to do |format|
          format.js { handle_invalid_update }
        end
      end
    end

    private

    def set_civil_servant
      @civil_servant = CivilServant.includes(:address).find(current_civil_servant.id)
    end

    def civil_servant_params
      CivilServantParamsModifier.call(params.require(:civil_servant).permit(*PERMITTED_CIVIL_SERVANT_PARAMS))
    end

    def handle_invalid_update
      partial_name = params[:form_partial]
      return respond_to_invalid_update(partial_name) if PERMITTED_FORM_PARTIALS.include?(partial_name)

      raise ActiveRecord::RecordNotFound, 'invalid form partial name'
    end

    def respond_to_invalid_update(form_partial)
      render(:update, locals: { form_partial: form_partial, civil_servant: @civil_servant })
    end
  end
end
