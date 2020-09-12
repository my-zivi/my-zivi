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
  end
end
