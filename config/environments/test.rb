# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = false
  config.action_controller.perform_caching = false
  config.action_view.cache_template_loading = true
  config.i18n.raise_on_missing_translations = true
  config.eager_load = false

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  config.consider_all_requests_local = true
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false

  config.active_storage.service = :test

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'example.com' }
  config.action_mailer.delivery_method = :test

  config.active_support.deprecation = :stderr
  config.active_job.queue_adapter = :test

  config.i18n.available_locales << :en # Fixes https://github.com/faker-ruby/faker/issues/266

  # TODO: Re-Enable Bullet
  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.bullet_logger = true
  #   Bullet.raise = true
  # end
end
