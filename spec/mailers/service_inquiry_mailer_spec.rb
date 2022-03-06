# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceInquiryMailer, type: :mailer do
  describe '#send_inquiry' do
    let(:service_inquiry) { create(:service_inquiry) }
    let(:mail) { described_class.with(service_inquiry_id: service_inquiry.id).send_inquiry }

    around do |spec|
      ClimateControl.modify(SERVICE_INQUIRY_RECIPIENT: 'recipient@example.com') do
        spec.run
      end
    end

    it 'renders the headers' do
      expect(mail.subject).to eq I18n.t('service_inquiry_mailer.send_inquiry.subject')
      expect(mail.to).to eq(['recipient@example.com'])
      expect(mail.reply_to).to eq([service_inquiry.email])
    end
  end

  describe '#send_confirmation' do
    let(:service_inquiry) { create(:service_inquiry) }
    let(:mail) { described_class.with(service_inquiry_id: service_inquiry.id).send_confirmation }

    it 'renders the headers' do
      expect(mail.subject).to eq I18n.t('service_inquiry_mailer.send_confirmation.subject')
      expect(mail.to).to eq([service_inquiry.email])
      expect(mail.reply_to).to eq([described_class::CONFIRMATION_MAIL_REPLY_TO])
    end
  end
end
