# frozen_string_literal: true

module CivilServants
  class RegistrationsController < ApplicationController
    include CivilServants::Concerns::AuthenticableAndAuthorizable

    before_action :load_civil_servant
    before_action :load_displayed_step

    def edit; end

    def update
      if @civil_servant.update(civil_servant_params)
        redirect_to civil_servants_register_path(displayed_step: @displayed_step.next.identifier)
      else
        flash[:error] = t('.erroneous_update')
        render :edit
      end
    end

    private

    def civil_servant_params
      params.require(:civil_servant).permit(
        :registration_step,
        :zdp, :first_name, :last_name, :hometown, :birthday,
        :phone, :iban, :health_insurance, :regional_center,
        {
          workshop_ids: [], driving_license_ids: [],
          address_attributes: %i[
            secondary_line street
            supplement city zip
          ]
        }
      )
    end

    def load_civil_servant
      @civil_servant = current_user.referencee

      authorize! :update, @civil_servant
    end

    def load_displayed_step
      @displayed_step =
        displayed_step_from_params ||
        displayed_step_from_civil_servant ||
        RegistrationStep.new(identifier: :personal)
    end

    def displayed_step_from_civil_servant
      @civil_servant.registration_step
    end

    def displayed_step_from_params
      step = RegistrationStep.new(identifier: params[:displayed_step].presence&.to_sym)
      return unless step.valid?
      return if @civil_servant.registration_step.nil? && !step.first?
      return if step.index - @civil_servant.registration_step.index > 1

      step
    end
  end
end
