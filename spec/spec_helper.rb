# frozen_string_literal: true

require 'simplecov'

unless ENV.fetch('NO_COVERAGE', false)
  SimpleCov.start 'rails' do
    add_filter 'app/channels/application_cable/channel.rb'
    add_filter 'app/channels/application_cable/connection.rb'
    add_filter 'app/jobs/application_job.rb'
    add_filter 'app/mailers/application_mailer.rb'
    add_filter 'app/models/application_record.rb'
    add_filter '.semaphore-cache'
    enable_coverage :branch
  end

  SimpleCov.maximum_coverage_drop 0
  SimpleCov.minimum_coverage 100

  require 'simplecov-console'
  if ENV['CI']
    SimpleCov.formatter SimpleCov::Formatter::Console
  else
    SimpleCov.formatter SimpleCov::Formatter::MultiFormatter.new([
                                                                   SimpleCov::Formatter::Console,
                                                                   SimpleCov::Formatter::HTMLFormatter
                                                                 ])
  end
end

require 'percy/capybara'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  Kernel.srand config.seed
end
