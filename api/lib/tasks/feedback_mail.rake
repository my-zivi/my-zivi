# frozen_string_literal: true

namespace :feedback_mail do
  desc 'Sends a feedback reminder to all users who have completed a service lately'
  task send: :environment do
    FeedbackReminderMailSenderService.new.send_reminders
  end
end
