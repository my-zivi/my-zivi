# frozen_string_literal: true

class MailingList < ApplicationRecord
  validates :organization, :name, :email, :telephone, presence: true
  validates :email, uniqueness: true

  after_create_commit :send_notification_email

  private

  def send_notification_email
    I18n.with_locale(:'de-CH') do
      MailingListEntryNotifierMailer.with(mailing_list_id: id).notify.deliver_later
    end
  end
end
