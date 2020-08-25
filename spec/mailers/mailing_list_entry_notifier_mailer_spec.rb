# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailingListEntryNotifierMailer, type: :mailer do
  describe '#notify' do
    let(:mail) { described_class.with(mailing_list_id: create(:mailing_list).id).notify }

    it 'renders the headers' do
      expect(mail.subject).to eq I18n.t('mailing_list_entry_notifier_mailer.notify.subject')
      expect(mail.to).to eq([MailingListEntryNotifierMailer::TO])
      expect(mail.cc).to eq MailingListEntryNotifierMailer::CC
    end
  end
end
