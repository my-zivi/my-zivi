# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_SENDER']
  layout 'mailer'
end
