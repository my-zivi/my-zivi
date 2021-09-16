# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

require 'spec_helper'
require 'capybara/rspec'
require 'capybara/rails'
require 'selenium/webdriver'
require 'cancan/matchers'
require 'super_diff/rspec-rails'
require 'vcr'

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ViewComponent::TestHelpers, type: :component
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include HaveInputFieldMatcher, type: :view
  config.include JavaScriptErrorReporter, type: :system, js: true

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

  # rubocop:disable Style/SymbolProc
  config.around(:each, :without_bullet) do |spec|
    # TODO: Re-Enable Bullet
    # previous_value = Bullet.enable?
    # Bullet.enable = false
    spec.run
    # ensure
    #   Bullet.enable = previous_value
  end
  # rubocop:enable Style/SymbolProc
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.ignore_hosts '127.0.0.1', 'localhost', 'chromedriver.storage.googleapis.com'
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes } unless ENV['CI']

  File.read(Rails.root.join('.env')).scan(/#?\s*(\S+)=\S*/).each do |key|
    config.filter_sensitive_data("[#{key}]") { ENV[key] } if key.match?(/secret|key|password/i)
  end

  config.before_record do |record|
    record.response.body.force_encoding('UTF-8')
  end
end
