# frozen_string_literal: true

module CivilServants
  module ServicesHelper
    def service_confirmation_text(service)
      tag.p(class: 'mb-0') do
        safe_join(
          [
            (tag.i(class: 'fas fa-check mr-1') if service.confirmation_date.present?),
            t(service.confirmation_date.present?,
              scope: %i[civil_servants services service_short_info_row service_confirmed])
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

    def schedule_information_table(service)
      TabularCardComponent.humanize_table_values(
        Service,
        beginning: I18n.l(service.beginning),
        ending: I18n.l(service.ending),
        'service_specification.location': service.service_specification.location,
        service_type: service.service_type
      )
    end
  end
end