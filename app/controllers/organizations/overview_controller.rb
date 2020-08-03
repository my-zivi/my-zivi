# frozen_string_literal: true

module Organizations
  class OverviewController < BaseController
    before_action -> { authorize! :read, :organization_overview }

    def index; end
  end
end
