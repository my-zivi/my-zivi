# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'algoliasearch-rails'
gem 'cancancan'
gem 'devise'
gem 'devise-i18n'
gem 'devise_invitable'
gem 'dotenv-rails'
gem 'flutie'
gem 'google-cloud-storage', '~> 1.31', require: false
gem 'hexapdf', '~> 0.21.1'
gem 'holidays'
gem 'iban-tools'
gem 'image_processing'
gem 'loaf', '~> 0.10.0'
gem 'nokogiri'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prawn'
gem 'prawn-table'
gem 'puma', '~> 5.6'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 6.1.5'
gem 'rails-i18n'
gem 'redis', '~> 4.0'
gem 'sepa_king'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'simple_form'
gem 'sitemap_generator'
gem 'slim-rails'
gem 'turbo-rails'
gem 'validates_timeliness'
gem 'view_component'
gem 'webpacker', '~> 5.2.1'
# gem 'jbuilder', '~> 2.7'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'rails_admin', '~> 2.1'

group :production do
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'norobots'
  gem 'sentry-rails'
  gem 'sentry-ruby'
end

group :development, :test do
  gem 'brakeman', require: false
  # TODO: Bullet does not yet support Rails 6.1.3.1, but that Rails version is required that ActiveStorage
  # works properly with the latest Google Cloud Services
  # => Reenable as soon as support was added
  # gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'reek', '~> 6.0.1'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails'
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'deepl-rb', require: false
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'slim_lint'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'climate_control'
  gem 'i18n-tasks'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'percy-capybara'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'super_diff'
  gem 'test-prof'
  gem 'vcr'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
