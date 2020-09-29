# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailingList, type: :model do
  describe 'validations' do
    subject(:model) { build(:mailing_list) }

    it { is_expected.to validate_uniqueness_of(:email) }

    it_behaves_like 'validates presence of required fields', %i[name organization telephone email]
  end

  describe 'after create' do
    it 'enqueues a notification email' do
      expect { create :mailing_list }.to have_enqueued_mail(MailingListEntryNotifierMailer)
    end
  end
end
