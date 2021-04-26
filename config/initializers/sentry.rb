# frozen_string_literal: true

if defined? Sentry
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger]
    config.environment = ENV['SENTRY_ENVIRONMENT']

    filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

    config.before_send = lambda do |event, _hint|
      filter.filter(event.to_hash)
    end

    # Performance Monitoring
    config.traces_sample_rate = 0.5
  end
end
