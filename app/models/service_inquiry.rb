# frozen_string_literal: true

class ServiceInquiry < ApplicationRecord
  belongs_to :job_posting

  validates :name, :email, :service_beginning, :service_duration, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  attr_accessor :skip_inquiry_mail

  after_create_commit :send_inquiry_mails

  private

  def send_inquiry_mails
    return if skip_inquiry_mail == true

    ServiceInquiryMailer.with(service_inquiry_id: id).send_inquiry.deliver_later
    ServiceInquiryMailer.with(service_inquiry_id: id).send_confirmation.deliver_later
  end
end
