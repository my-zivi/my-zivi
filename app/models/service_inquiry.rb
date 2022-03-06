# frozen_string_literal: true

class ServiceInquiry < ApplicationRecord
  belongs_to :job_posting

  validates :name, :email, :service_beginning, :service_duration, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
