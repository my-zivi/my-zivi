# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'devise'
gem 'dotenv-rails'
gem 'fillable-pdf'
gem 'hexapdf'
gem 'iban-tools'
gem 'prawn'
gem 'prawn-table'
gem 'rack-cors', require: 'rack/cors'
gem 'rails-i18n'
gem 'sepa_king'
gem 'simple_form'
gem 'validates_timeliness'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
# gem 'jbuilder', '~> 2.7'

gem 'bootsnap', '>= 1.4.2', require: false

group :production do
  gem 'lograge'
  gem 'norobots'
  gem 'sentry-raven'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'selenium-webdriver'
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
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'climate_control'
  gem 'i18n-tasks', '~> 0.9.29'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'test-prof'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
