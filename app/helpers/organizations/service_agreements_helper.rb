# frozen_string_literal: true

module Organizations
  module ServiceAgreementsHelper
    include Rails.application.routes.url_helpers

    COLUMNS = {
      full_name: {
        sort: true,
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

    ACTIONS = {
      edit: {
        icon_classes: 'fas fa-pen',
        link_path: lambda { |service_agreement|
                     Rails.application.routes
                          .url_helpers.edit_organizations_civil_servant_service_path(
                            service_agreement.civil_servant,
                            service_agreement
                          )
                   },
        link_args: {
          class: 'mr-3',
          title: I18n.t('edit'),
          data: { toggle: 'tooltip', placement: 'above' }
        }
      },
      delete: {
        icon_classes: 'fas fa-trash',
        link_path: lambda { |service_agreement|
                     Rails.application
                          .routes
                          .url_helpers
                          .organizations_service_agreement_path(service_agreement)
                   },
        link_args: {
          class: 'mr-3',
          method: :delete,
          title: I18n.t('destroy'),
          data: {
            confirm: I18n.t('organizations.service_agreements.confirm_destroy'),
            toggle: 'tooltip',
            placement: 'above'
          }
        }
      }
    }.freeze

    def service_agreements_table_columns
      COLUMNS
    end

    def service_agreements_table_actions
      ACTIONS
    end
  end
end
