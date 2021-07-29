# frozen_string_literal: true

module CivilServants
  class OverviewController < BaseController
    before_action -> { authorize! :read, :civil_servant_overview }
    before_action :set_civil_servant, only: :index

    def index; end

    def set_civil_servant
      @civil_servant = CivilServant.includes(:services).find(current_civil_servant.id)
    end
  end
end
