# frozen_string_literal: true

if defined? Sidekiq
  SCHEDULE_FILE = 'config/schedule.yml'

  if File.exist?(SCHEDULE_FILE) && Sidekiq.server?
    errors = Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(SCHEDULE_FILE))
    Rails.logger.error "Errors loading scheduled jobs: #{errors}" if errors.any?
  end
end
