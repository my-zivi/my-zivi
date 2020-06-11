# frozen_string_literal: true

require 'spec_helper'
require 'capybara/rspec'
require 'capybara/rails'
require 'selenium/webdriver'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:all, type: :system) do
    Capybara.server = :puma, { Silent: true }
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome
  end

  config.after { I18n.locale = I18n.default_locale }

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.after(:each, type: :system, js: true) do
    errors = page.driver.browser.manage.logs.get(:browser)
    if errors.present?
      aggregate_failures 'javascript errors' do
        errors.each do |error|
          expect(error.level).not_to eq('SEVERE'), error.message
          next unless error.level == 'WARNING'

          warn 'WARN: javascript warning'
          warn error.message
        end
      end
    end
  end
end
