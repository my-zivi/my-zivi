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
      delete: {
        icon_classes: 'fas fa-trash text-danger mr-3',
        link_text: I18n.t('organizations.service_agreements.service_agreement_row.delete'),
        link_path: lambda { |service_agreement|
          Rails.application
               .routes
               .url_helpers
               .organizations_service_agreement_path(service_agreement)
        },
        link_args: {
          class: 'dropdown-item',
          method: :delete,
          title: I18n.t('organizations.service_agreements.service_agreement_row.delete'),
          data: {
            confirm: I18n.t('organizations.service_agreements.confirm_destroy'),
            toggle: 'tooltip',
            placement: 'above'
          }
        }
      }
    }.freeze

    def service_agreements_organization_table_columns
      COLUMNS
    end

    def service_agreements_organization_table_actions
      ACTIONS
    end

    def civil_servant_search_options
      {
        options: {
          ajax: {
            url: organizations_service_agreement_civil_servant_search_path(format: :json),
            dataType: 'json',
            delay: 250
          },
          placeholder: I18n.t('organizations.service_agreements.search.modal.input_placeholder'),
          dropdownParent: '#new_service_agreement',
          allowClear: true
        }
      }
    end

    def service_agreement_beginning_date_picker(form, service_agreement)
      date_picker(form, :beginning, service_agreement.beginning,
                  required: true, minDate: I18n.l(Time.zone.today),
                  enable: valid_beginning_dates(service_agreement))
    end

    def service_agreement_ending_date_picker(form, service_agreement)
      date_picker(form, :ending, service_agreement.ending, required: true,
                                                           minDate: I18n.l(Time.zone.today.at_end_of_week - 2.days),
                                                           enable: valid_ending_dates(service_agreement))
    end

    private

    def valid_beginning_dates(service)
      return [] if service.probation_civil_service?

      (Time.zone.today..Time.zone.today + 5.years).select(&:monday?).map { |day| I18n.l(day) }
    end

    def valid_ending_dates(service)
      return [] if service.probation_civil_service? || service.last_service?

      (Time.zone.today..Time.zone.today + 5.years).select(&:friday?).map { |day| I18n.l(day) }
    end
  end
end
