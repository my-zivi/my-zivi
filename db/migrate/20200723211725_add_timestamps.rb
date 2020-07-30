# frozen_string_literal: true

class AddTimestamps < ActiveRecord::Migration[6.0]
  TABLES = %i[
    addresses
    civil_servants
    civil_servants_driving_licenses
    civil_servants_workshops
    driving_licenses
    driving_licenses_service_specifications
    expense_sheets
    organization_holidays
    organization_members
    organizations
    payments
    regional_centers
    service_specifications
    service_specifications_workshops
    services
    users
    workshops
  ].freeze

  def change
    TABLES.each { |table| add_timestamps table }
  end
end
