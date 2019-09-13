# frozen_string_literal: true

class FeedbackReminderMailSenderService
  def send_reminders
    Service
      .where(feedback_mail_sent: false)
      .where(Service.arel_table[:ending].lt(Time.zone.now))
      .each(&:send_feedback_reminder)
  end
end
