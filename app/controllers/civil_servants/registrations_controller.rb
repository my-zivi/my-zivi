# frozen_string_literal: true

module CivilServants
  class RegistrationsController < ApplicationController
    include CivilServants::Concerns::AuthenticableAndAuthorizable

    before_action :load_civil_servant

    def edit; end

    def update; end

    private

    def load_civil_servant
      @civil_servant = current_user.referencee

      authorize! :update, @civil_servant
    end
  end
end
