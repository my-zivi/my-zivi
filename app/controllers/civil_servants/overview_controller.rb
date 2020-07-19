# frozen_string_literal: true

module CivilServants
  class OverviewController < BaseController
    before_action -> { authorize! :read, :civil_servant_overview }

    def index; end
  end
end
