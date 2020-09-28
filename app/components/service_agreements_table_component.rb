# frozen_string_literal: true

class ServiceAgreementsTableComponent < ViewComponent::Base
  COLUMNS = {
    full_name: {
      label: I18n.t('activerecord.models.civil_servant'),
      content: ->(service_agreement) { service_agreement.civil_servant.full_name }
    },
    beginning: {
      label: I18n.t('activerecord.attributes.service.beginning'),
      content: ->(service_agreement) { I18n.l(service_agreement.beginning) }
    },
    ending: {
      label: I18n.t('activerecord.attributes.service.ending'),
      content: ->(service_agreement) { I18n.l(service_agreement.ending) }
    },
    duration: {
      label: I18n.t('activerecord.attributes.service.service_days'),
      content: lambda do |service_agreement|
        I18n.t('organizations.service_agreements.index.days',
               count: service_agreement.service_days,
               amount: service_agreement.service_days)
      end
    }
  }.freeze

  def initialize(service_agreements:, columns: COLUMNS)
    @service_agreements = service_agreements
    @columns = columns

    super
  end
end
