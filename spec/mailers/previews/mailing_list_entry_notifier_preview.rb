# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/mailing_list_entry_notifier
class MailingListEntryNotifierPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/mailing_list_entry_notifier/notify
  def notify
    MailingListEntryNotifierMailer.with(mailing_list_id: MailingList.first.id).notify
  end
end
