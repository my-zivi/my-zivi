# frozen_string_literal: true

module CivilServants
  class CivilServantsController < BaseController
    PERMITTED_CIVIL_SERVANT_PARAMS = [
      :zdp, :first_name, :last_name, :hometown, :birthday,
      :phone, :iban, :health_insurance, :regional_center_id,
      workshop_ids: [], driving_license_ids: [],
      user_attributes: %i[email language id],
      address_attributes: %i[
        primary_line secondary_line street
        supplement city zip
      ]
    ].freeze

    include UsersHelper

    def show; end

    def edit; end

    def update
      civil_servant = current_civil_servant

      if civil_servant.update(civil_servant_params)
        flash[:success] = t('.successfully_updated')
        redirect_to edit_civil_servants_civil_servant_path
      else
        respond_to do |format|
          format.js do
            render :edit, locals: { form_partial: params[:form_partial], civil_servant: civil_servant }
          end
        end
      end
    end

    private

    def civil_servant_params
      params.require(:civil_servant).permit(*PERMITTED_CIVIL_SERVANT_PARAMS)
    end
  end
end
