# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceInquiry, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[name email service_beginning service_duration message]
  end

  describe 'after create' do
    it 'enqueues inquiry mails after create commit' do
      expect { create(:service_inquiry, send_inquiry_mails: true) }.to(
        have_enqueued_email(ServiceInquiryMailer, :send_confirmation).and(
          have_enqueued_email(ServiceInquiryMailer, :send_inquiry)
        )
      )
    end

    context 'when skip_inquiry_mail is set' do
      it 'does not enqueue inquiry emails' do
        expect { create(:service_inquiry, send_inquiry_mails: false) }.not_to(
          have_enqueued_email(ServiceInquiryMailer, :send_inquiry)
        )
      end
    end
  end

  describe '#agreement=' do
    subject(:model) { build(:service_inquiry) }

    it 'sets agreement to true if value is "1"' do
      model.agreement = '1'
      expect(model.agreement).to be true
    end

    it 'sets agreement to false if value is "0"' do
      model.agreement = '0'
      expect(model.agreement).to be false
    end

    it 'sets agreement to true if value is true' do
      model.agreement = true
      expect(model.agreement).to be true
    end
  end
end
