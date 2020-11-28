# frozen_string_literal: true

def click_accept_service(row_number)
  click_dropdown_element_within(
    "tbody tr:nth(#{row_number})",
    "a[title=\"#{I18n.t('civil_servants.service_agreements.index.accept_service')}\"]"
  )
end

def click_decline_service(row_number)
  click_dropdown_element_within(
    "tbody tr:nth(#{row_number})",
    "a[title=\"#{I18n.t('civil_servants.service_agreements.index.decline_service')}\"]"
  )
end
