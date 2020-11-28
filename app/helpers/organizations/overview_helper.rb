# frozen_string_literal: true

module Organizations
  module OverviewHelper
    def current_week_phone_list_path
      organizations_phone_list_path(format: :pdf,
                                    params: { filters: {
                                      beginning: Time.zone.today.beginning_of_week,
                                      ending: Time.zone.today.at_end_of_week
                                    } })
    end

    def current_month_phone_list_path
      organizations_phone_list_path(format: :pdf,
                                    params: { filters: {
                                      beginning: Time.zone.today.beginning_of_month,
                                      ending: Time.zone.today.at_end_of_month
                                    } })
    end

    def active_civil_servants_count
      current_organization.services.active.count
    end

    def editable_expense_sheets_count
      current_organization.expense_sheets.editable.count
    end

    # @param [Service] service
    # rubocop:disable Metrics/AbcSize
    def service_state_label(service)
      {
        (service.civil_servant_agreed? && service.confirmation_date.present?) => I18n.t('service_states.active'),
        (service.civil_servant_agreed? && service.confirmation_date.nil?) => I18n.t('service_states.pending_contract'),
        service.civil_servant_decided_at.nil? => I18n.t('service_states.waiting_for_civil_servant_decision'),
        (service.civil_servant_decided_at.present? && !service.civil_servant_agreed?) =>
          I18n.t('service_states.civil_servant_rejected')
      }.fetch(true, nil)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
