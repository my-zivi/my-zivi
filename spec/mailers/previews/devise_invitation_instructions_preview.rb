# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/mailing_list_entry_notifier
class DeviseInvitationInstructionsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/mailing_list_entry_notifier/notify
  def invitation_instructions
    Devise.mailer.invitation_instructions(CivilServant.last.user, 'fake-super-invitation-token')
  end
end
