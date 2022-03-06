# frozen_string_literal: true

class ServiceInquiryMailer < ApplicationMailer
  CONFIRMATION_MAIL_REPLY_TO = 'info@myzivi.ch'

  def send_inquiry
    @service_inquiry = ServiceInquiry.find(params[:service_inquiry_id])
    @job_posting = @service_inquiry.job_posting

    german_mail to: ENV['SERVICE_INQUIRY_RECIPIENT'], reply_to: @service_inquiry.email
  end

  def send_confirmation
    @service_inquiry = ServiceInquiry.find(params[:service_inquiry_id])

    german_mail to: @service_inquiry.email,
                reply_to: CONFIRMATION_MAIL_REPLY_TO,
                from: "Joshua Devadas <#{ENV['MAIL_SENDER']}>"
  end

  private

  def german_mail(...)
    I18n.with_locale(:'de-CH') do
      mail(...)
    end
  end
end
