# frozen_string_literal: true

module CivilServants
  module ServicesHelper
    def service_confirmation_text(service)
      tag.p(class: 'mb-0') do
        safe_join(
          [
            (tag.i(class: 'fas fa-check mr-1') if service.confirmation_date.present?),
            t(service.confirmation_date.present?,
              scope: %i[base services short_info_cell service_confirmed])
          ]
        )
      end
    end

    def service_row_class(service)
      return '' unless service.past?

      'inactive-service'
    end

    def organization_information_table(service)
      org = service.organization
      org_address = org.address

      TabularCardComponent.humanize_table_values(
        Organization,
        name: org.name,
        address: simple_format(org_address.full_compose)
      )
    end

    def civil_servant_information_table(service)
      civi_address = service.civil_servant.address
      spec = service.service_specification

      TabularCardComponent.humanize_table_values(
        Service,
        'civil_servant.address': simple_format(civi_address.full_compose),
        'service_specification': spec.name
      )
    end

    def schedule_information_table(service)
      TabularCardComponent.humanize_table_values(
        Service,
        beginning: I18n.l(service.beginning),
        ending: I18n.l(service.ending),
        'service_specification.location': service.service_specification.location,
        service_type: enum_l(service, :service_type)
      )
    end
  end
end
