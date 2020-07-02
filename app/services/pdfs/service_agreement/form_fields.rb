# frozen_string_literal: true

module Pdfs
  module ServiceAgreement
    module FormFields
      CIVIL_SERVANT_FORM_FIELDS = {
        fr: {
          zdp: 'N',
          first_name: 'Prénom',
          last_name: 'Nom',
          phone: 'Mobile',
          iban: 'IBAN',
          health_insurance: 'Caisse-maladie'
        },
        de: {
          zdp: 1,
          first_name: 2,
          last_name: 7,
          phone: 4,
          iban: 10,
          health_insurance: 11
        }
      }.freeze

      CIVIL_SERVANT_USER_FORM_FIELDS = {
        fr: {
          email: 'Courriel'
        },
        de: {
          email: 5
        }
      }.freeze

      CIVIL_SERVANT_ADDRESS_FORM_FIELDS = {
        fr: {
          zip_with_city: 'NPA / Lieu',
          street: 'Rue n'
        },
        de: {
          zip_with_city: 3,
          street: 8
        }
      }.freeze

      SERVICE_DATE_FORM_FIELDS = {
        fr: {
          beginning: 'Date de début',
          ending: 'Date de fin'
        },
        de: {
          beginning: 25,
          ending: 24
        }
      }.freeze

      SERVICE_CHECKBOX_FIELDS = {
        fr: {
          normal_civil_service: 'affectation',
          probation_civil_service: 'affectation à lessai',
          long_civil_service: 'affectation longue obligatoire ou partie de celleci'
        },
        de: {
          normal_civil_service: 'Einsatz',
          probation_civil_service: 'Probeeinsatz',
          long_civil_service: 'obligatorischer Langer Einsatz oder Teil davon'
        }
      }.freeze

      SERVICE_SPECIFICATION_FORM_FIELDS = {
        fr: {
          title: 'Cahier des charges'
        },
        de: {
          title: 26
        }
      }.freeze

      COMPANY_HOLIDAY_FORM_FIELDS = {
        fr: {
          beginning: 'Fermeture1',
          ending: 'Fermeture2'
        },
        de: {
          beginning: 27,
          ending: 28
        }
      }.freeze
    end
  end
end
