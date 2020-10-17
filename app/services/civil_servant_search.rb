# frozen_string_literal: true

class CivilServantSearch
  class << self
    def call(term, current_organization)
      [
        organization_civil_servant_lookup_group(term, current_organization),
        all_civil_servant_lookup_group(term),
        new_civil_servant_lookup_group
      ]
    end

    private

    def organization_civil_servant_lookup_group(term, current_organization)
      {
        text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.recent_civil_servants'),
        children: organization_civil_servant_lookup_results(term, current_organization)
      }
    end

    def all_civil_servant_lookup_group(term)
      {
        text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.all_civil_servants'),
        children: all_civil_servant_lookup_results(term)
      }
    end

    def new_civil_servant_lookup_group
      {
        text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.new_civil_servant'),
        children: [{
          id: -1,
          text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.new_civil_servant')
        }]
      }
    end

    def organization_civil_servant_lookup_results(term, current_organization)
      select_and_map_civil_servants(filtered_organization_civil_servants(term, current_organization))
    end

    def all_civil_servant_lookup_results(term)
      select_and_map_civil_servants(filtered_all_civil_servants(term))
    end

    def filtered_all_civil_servants(term)
      if term.present?
        CivilServant.search(term).distinct
      else
        CivilServant.all.distinct.order(:first_name, :last_name)
      end
    end

    def filtered_organization_civil_servants(term, current_organization)
      filtered_all_civil_servants(term)
        .joins(services: :service_specification)
        .where(services: { service_specifications: { organization_id: current_organization.id } })
    end

    def select_and_map_civil_servants(query)
      query
        .joins(:user)
        .limit(20)
        .select('civil_servants.id', 'civil_servants.first_name',
                'civil_servants.last_name', 'users.email as user_email')
        .map(&method(:civil_servant_search_object))
    end

    def civil_servant_search_object(civil_servant)
      {
        id: civil_servant.user_email,
        text: "#{civil_servant.full_name}, #{civil_servant.user_email}"
      }
    end
  end
end
