# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbackReminderMailSenderService, type: :service do
  subject(:service) { described_class.new }

  describe '#send_reminders' do
    let(:included_ending) { Time.zone.now.at_end_of_week - 1.week - 2.days }
    let(:excluded_ending) { Time.zone.now.at_end_of_week + 1.week - 2.days }
    let!(:included_services) { create_pair :service, ending: included_ending }
    let(:already_sent_service) { create :service, ending: included_ending, feedback_mail_sent: true }
    let!(:excluded_services) { create_pair(:service, ending: excluded_ending) << already_sent_service }

    it 'sends mail to the users of completed services' do
      expect { service.send_reminders }.to change { ActionMailer::Base.deliveries.count }.by(included_services.length)
    end

    it 'sets #feedback_mail_sent to true for done services' do
      expect { service.send_reminders }.to(
        change { included_services.map(&:reload).map(&:feedback_mail_sent).all? }.from(false).to(true)
      )
    end

    it 'does not touch the excluded services' do
      expect { service.send_reminders }.not_to(change { excluded_services.map(&:reload) })
    end
  end
end
