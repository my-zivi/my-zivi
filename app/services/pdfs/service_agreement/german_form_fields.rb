# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    module GermanFormFields
      SERVICE_AGREEMENT_FIELDS = {
        'ZDP-Nr' => ->(service:) { service.civil_servant.zdp },
        'Vorname' => ->(service:) { service.civil_servant.first_name },
        'PLZ / Ort' => ->(service:) { service.civil_servant.address.zip_with_city },
        'Telefon' => ->(service:) { service.civil_servant.phone },
        'E-Mail' => ->(service:) { service.civil_servant.user.email },
        'Geb.datum' => ->(service:) { I18n.l service.civil_servant.birthday },
        'Name' => ->(service:) { service.civil_servant.last_name },
        'Strasse / Nr.' => ->(service:) { service.civil_servant.address.street },
        'IBAN' => ->(service:) { service.civil_servant.iban },
        'Krankenkasse (Name und Ort)' => ->(service:) { service.civil_servant.health_insurance },
        'EiB-Nr.' => ->(service:) { service.service_specification.organization.identification_number },
        # '13' => ->(service:) { service.service_specification.contact_person.full_name },
        'Strasse / Nr (EIB)' => ->(service:) { service.service_specification.organization.address.street },
        # '15' => ->(service:) { service.service_specification.contact_person.phone },
        'EiB-Name' => ->(service:) { service.service_specification.organization.name },
        # '17' => ->(service:) { service.service_specification.contact_person.organization_role },
        'PLZ / Ort (EIB)' => ->(service:) { service.service_specification.organization.address.zip_with_city },
        # '19' => ->(service:) { service.service_specification.contact_person.email },
        'Weisungsberechtigte Person' => ->(service:) { service.service_specification.lead_person.full_name },
        'Funktion' => ->(service:) { service.service_specification.lead_person.organization_role },
        'WBP Telefon' => ->(service:) { service.service_specification.lead_person.phone },
        'Arbeitsort' => ->(service:) { service.service_specification.location },
        'Einsatzbeginn' => ->(service:) { I18n.l service.beginning },
        'Einsatzende' => ->(service:) { I18n.l service.ending },
        'Pflichtenheft' => ->(service:) { service.service_specification.title },
      }.freeze
    end
  end
end
