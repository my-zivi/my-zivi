# frozen_string_literal: true

if defined? Sentry
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger]
    config.environment = ENV['SE']

    filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

    config.before_send = lambda do |event, _hint|
      filter.filter(event.to_hash)
    end

    # To activate performance monitoring, set one of these options.
    # We recommend adjusting the value in production:
    config.traces_sample_rate = 0.5
    # or
    config.traces_sampler = lambda do |context|
      true
    end
  end
end

