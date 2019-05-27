# frozen_string_literal: true

module ServicePdfFields
  USER_FORM_FIELDS = {
    fr: {
      zdp: 'N',
      first_name: 'Prénom',
      last_name: 'Nom',
      zip_with_city: 'NPA / Lieu',
      address: 'Rue n',
      phone: 'Mobile',
      bank_iban: 'IBAN',
      email: 'Courriel',
      health_insurance: 'Caisse-maladie'
    },
    de: {
      zdp: 1,
      first_name: 2,
      last_name: 7,
      zip_with_city: 3,
      address: 8,
      phone: 4,
      bank_iban: 10,
      email: 5,
      health_insurance: 11
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
      conventional_service: 'affectation',
      probation_service: 'affectation à lessai',
      long_service: 'affectation longue obligatoire ou partie de celleci'
    },
    de: {
      conventional_service: 'Einsatz',
      probation_service: 'Probeeinsatz',
      long_service: 'obligatorischer Langer Einsatz oder Teil davon'
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
end
