# frozen_string_literal: true

class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    Devise.mailer.reset_password_instructions(User.last, 'fake')
  end
end
