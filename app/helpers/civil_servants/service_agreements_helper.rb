# frozen_string_literal: true

module CivilServants
  module ServiceAgreementsHelper
    include Rails.application.routes.url_helpers

    COLUMNS = {
      beginning: {
        label: I18n.t('activerecord.attributes.service.beginning'),
        content: ->(service_agreement) { I18n.l(service_agreement.beginning) }
      },
      ending: {
        label: I18n.t('activerecord.attributes.service.ending'),
        content: ->(service_agreement) { I18n.l(service_agreement.ending) }
      },
      organization_name: {
        sort: true,
        label: I18n.t('activerecord.models.organization'),
        content: ->(service_agreement) { service_agreement.organization.name }
      },
      service_specification: {
        label: I18n.t('activerecord.models.service_specification'),
        content: ->(service_agreement) { service_agreement.service_specification.name }
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
      decline: {
        icon_classes: 'fas fa-times text-danger mr-3',
        link_text: I18n.t('civil_servants.service_agreements.index.decline_service'),
        link_path: lambda { |service_agreement|
          Rails.application
               .routes
               .url_helpers
               .civil_servants_service_agreement_decline_path(service_agreement)
        },
        link_args: {
          class: 'dropdown-item',
          title: I18n.t('civil_servants.service_agreements.index.decline_service'),
          data: {
            confirm: I18n.t('civil_servants.service_agreements.index.confirm_decline'),
            toggle: 'tooltip',
            placement: 'above'
          },
          method: :patch
        }
      },
      accept: {
        icon_classes: 'fas fa-check text-success mr-3',
        link_text: I18n.t('civil_servants.service_agreements.index.accept_service'),
        link_path: lambda { |service_agreement|
          Rails.application
               .routes
               .url_helpers
               .civil_servants_service_agreement_accept_path(service_agreement)
        },
        link_args: {
          class: 'dropdown-item',
          title: I18n.t('civil_servants.service_agreements.index.accept_service'),
          data: {
            confirm: I18n.t('civil_servants.service_agreements.index.confirm_acceptance'),
            toggle: 'tooltip',
            placement: 'above'
          },
          method: :patch
        }
      }
    }.freeze

    def service_agreements_civil_servant_table_columns
      COLUMNS
    end

    def service_agreements_civil_servant_table_actions
      ACTIONS
    end
  end
end
