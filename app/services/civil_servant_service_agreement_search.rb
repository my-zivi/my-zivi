# frozen_string_literal: true

class CivilServantServiceAgreementSearch
  class << self
    def filtered_all_civil_servants(term)
      if term.present?
        CivilServant.search(term)
      else
        CivilServant.all.order(:first_name, :last_name)
      end
    end

    def filtered_organization_civil_servants(term, current_organization)
      filtered_all_civil_servants(term)
        .joins(services: :service_specification)
        .where(services: { service_specifications: { organization_id: current_organization.id } })
    end
  end
end
