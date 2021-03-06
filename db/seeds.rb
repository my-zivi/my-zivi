# frozen_string_literal: true

puts 'Seeding database...'

require_relative 'seed_data/workshops'
require_relative 'seed_data/driving_licenses'
require_relative 'seed_data/civil_servants'
require_relative 'seed_data/organizations'
require_relative 'seed_data/organization_holidays'
require_relative 'seed_data/organization_members'
require_relative 'seed_data/service_specifications'
require_relative 'seed_data/services'
require_relative 'seed_data/expense_sheets_and_payments'
require_relative 'seed_data/sys_admins'
require_relative 'seed_data/blog_entries'
require_relative 'seed_data/job_postings'

puts 'Done :)'
