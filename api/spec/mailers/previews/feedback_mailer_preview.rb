# frozen_string_literal: true

# Preview all emails at http://localhost:28000/rails/mailers/feedback_mailer
# Rails server must be running
class FeedbackMailerPreview < ActionMailer::Preview
  def feedback_reminder_mail
    FeedbackMailer.feedback_reminder_mail(User.new(first_name: 'Peter', last_name: 'Parker'))
  end
end
