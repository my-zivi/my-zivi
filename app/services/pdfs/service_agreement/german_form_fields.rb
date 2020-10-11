# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    module GermanFormFields
      SERVICE_AGREEMENT_FIELDS = {
        '1' => ->(service:) { service.civil_servant.zdp },
        '2' => ->(service:) { service.civil_servant.first_name },
        '3' => ->(service:) { service.civil_servant.address.zip_with_city },
        '4' => ->(service:) { service.civil_servant.phone },
        '5' => ->(service:) { service.civil_servant.user.email },
        # '6' => ->(service:) { service.civil_servants.job_education },
        '7' => ->(service:) { service.civil_servant.last_name },
        '8' => ->(service:) { service.civil_servant.address.street },
        # '9' => ->(service:) { service.civil_servants.private_phone },
        '10' => ->(service:) { service.civil_servant.iban },
        '11' => ->(service:) { service.civil_servant.health_insurance },
        '12' => ->(service:) { service.service_specification.organization.identification_number },
        '13' => ->(service:) { service.service_specification.contact_person.full_name },
        '14' => ->(service:) { service.service_specification.organization.address.street },
        '15' => ->(service:) { service.service_specification.contact_person.phone },
        '16' => ->(service:) { service.service_specification.organization.name },
        '17' => ->(service:) { service.service_specification.contact_person.organization_role },
        '18' => ->(service:) { service.service_specification.organization.address.zip_with_city },
        '19' => ->(service:) { service.service_specification.contact_person.email },
        '20' => ->(service:) { service.service_specification.lead_person.full_name },
        '21' => ->(service:) { service.service_specification.lead_person.organization_role },
        '22' => ->(service:) { service.service_specification.lead_person.phone },
        '23' => ->(service:) { service.service_specification.location },
        '25' => ->(service:) { service.beginning },
        '24' => ->(service:) { service.ending },
        '26' => ->(service:) { service.service_specification.title },
        # '27' => -> (company_holiday:) {company_holiday.beginning },
        # '28' => -> (company_holiday:) {company_holiday.ending },
        # '29' => -> (service:) {service.service_specification.service_specifications_workshops.first_workshop.name },
        # '30' => -> (service:) {second_workshop.name },
        # '31' => -> (service:) {third_workshop.name },
        'Einsatz' => ->(service:) { service.normal_civil_service? },
        'Probeeinsatz' => ->(service:) { service.probation_civil_service? },
        'obligatorischer Langer Einsatz oder Teil davon' => ->(service:) { service.long_civil_service? },
        'cbRZ' => ->(service:) { service.civil_servant.regional_center.identifier },
        'tfRZ' => ->(service:) { service.civil_servant.regional_center.name },
        'tfStrasse' => ->(service:) { service.civil_servant.regional_center.address.street },
        'tfPLZ' => ->(service:) { service.civil_servant.regional_center.address.zip_with_city }
        # 'Ort Datum' => ->(service:) { service.civil_servants.signature_location_and_date },
        # 'Ort Datum_2' => ->(service:) { service.service_specification.organization.signature_location_and_date },
        # 'D' => ->(service:) { service.civil_servants.workshop_language_german? },
        # 'E' => ->(service:) { service.civil_servants.workshop_language_english? },
        # 'F' => ->(service:) { service.civil_servants.workshop_language_french? },
        # 'I' => ->(service:) { service.civil_servants.workshop_language_italian? },
        # 'BEM' => ->(service:) { service.service_specification.comment }
      }.freeze
    end
  end
end
