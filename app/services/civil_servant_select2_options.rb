# frozen_string_literal: true

class CivilServantSelect2Options
  class << self
    def call(all_civil_servants, organization_civil_servant)
      [
        organization_civil_servant_lookup_group(organization_civil_servant),
        all_civil_servant_lookup_group(all_civil_servants),
        new_civil_servant_lookup_group
      ]
    end

    private

    def organization_civil_servant_lookup_group(civil_servants)
      {
        text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.recent_civil_servants'),
        children: select_and_map_civil_servants(civil_servants)
      }
    end

    def all_civil_servant_lookup_group(civil_servants)
      {
        text: I18n.t('organizations.service_agreements.search.modal.dropdown.groups.all_civil_servants'),
        children: select_and_map_civil_servants(civil_servants)
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

    def select_and_map_civil_servants(query)
      query
        .joins(:user)
        .distinct
        .limit(20)
        .select('civil_servants.id', 'civil_servants.first_name',
                'civil_servants.last_name', 'users.email as user_email')
        .map { |civil_servant| civil_servant_search_object(civil_servant) }
        .reject { |search_object| search_object[:id].empty? || search_object[:text].empty? }
    end

    def civil_servant_search_object(civil_servant)
      {
        id: civil_servant.user_email,
        text: "#{civil_servant.full_name}, #{civil_servant.user_email}"
      }
    end
  end
end
