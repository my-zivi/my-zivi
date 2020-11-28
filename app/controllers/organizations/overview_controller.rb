# frozen_string_literal: true

module Organizations
  class OverviewController < BaseController
    before_action -> { authorize! :read, :organization_overview }

    def index
      accessible_services = Service.accessible_by(current_ability)
      @services = accessible_services
                  .where(civil_servant_decided_at: nil)
                  .or(accessible_services.where(confirmation_date: nil, civil_servant_agreed: true))
                  .includes(:civil_servant, :service_specification)
                  .order(civil_servant_agreed: :desc, confirmation_date: :desc, beginning: :asc)
    end
  end
end
