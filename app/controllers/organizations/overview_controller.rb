# frozen_string_literal: true

module Organizations
  class OverviewController < BaseController
    before_action -> { authorize! :read, :organization_overview }
    breadcrumb 'organizations.overview', :organizations_path

    def index
      @services = can?(:read, Service) ? load_services : Service.none
    end

    private

    def load_services
      Service.accessible_by(current_ability)
             .where(civil_servant_decided_at: nil)
             .or(Service.accessible_by(current_ability).where(confirmation_date: nil, civil_servant_agreed: true))
             .includes(:civil_servant, :service_specification)
             .order(civil_servant_agreed: :desc, confirmation_date: :desc, beginning: :asc)
    end
  end
end
