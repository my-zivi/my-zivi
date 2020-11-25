# frozen_string_literal: true

module CivilServants
  class RegistrationsController < ApplicationController
    PERMITTED_PARAMS = [:zdp, :first_name, :last_name, :hometown, :birthday,
                        :phone, :iban, :health_insurance, :regional_center,
                        {
                          workshop_ids: [], driving_license_ids: [],
                          address_attributes: %i[
                            primary_line secondary_line street
                            supplement city zip
                          ]
                        }].freeze

    include ::AuthenticableAndAuthorizable

    before_action :load_civil_servant
    before_action :load_displayed_step

    def edit
      @civil_servant.address ||= Address.new(primary_line: @civil_servant.full_name)
    end

    def update
      if @civil_servant.update(civil_servant_params)
        respond_to_successful_update
      else
        flash[:error] = t('.erroneous_update')
        render :edit
      end
    end

    private

    def respond_to_successful_update
      if @civil_servant.registration_step.last?
        flash[:success] = I18n.t('successful_registration')
        redirect_to civil_servants_path
      else
        redirect_to civil_servants_register_path(displayed_step: @displayed_step.next.identifier)
      end
    end

    def civil_servant_params
      params
        .require(:civil_servant)
        .permit(*PERMITTED_PARAMS)
        .merge(registration_step: @displayed_step)
    end

    def load_civil_servant
      @civil_servant = current_user.referencee

      authorize! :access, :registration_page
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
      return if @civil_servant.registration_step.nil? # Registration not begun yet, fallback to default
      return if step.index - @civil_servant.registration_step.index > 1 # Do not allow skipping steps

      step
    end
  end
end
