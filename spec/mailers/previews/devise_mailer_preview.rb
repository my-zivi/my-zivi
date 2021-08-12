# frozen_string_literal: true

class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    Devise.mailer.reset_password_instructions(User.last, 'fake')
  end

  def confirmation_instructions
    Devise.mailer.confirmation_instructions(User.last, 'fake')
  end

  def email_changed
    Devise.mailer.email_changed(User.last)
  end

  def password_change
    Devise.mailer.password_change(User.last)
  end
end
