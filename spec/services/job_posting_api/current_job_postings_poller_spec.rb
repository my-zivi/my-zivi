# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingApi::CurrentJobPostingsPoller, :vcr do
  around do |spec|
    envs = {
      CURRENT_JOB_POSTINGS_API_URL: 'https://scraper.myzivi.ch/dev/current_postings.xml',
      APP_HOST: 'myzivi.ch'
    }

    ClimateControl.modify(envs) { spec.run }
  end

  describe '#perform' do
    subject(:poller) { described_class.new }

    let!(:workshop) { create(:workshop, name: 'Kommunikation & Betreuung') }

    # rubocop:disable RSpec/ExampleLength
    # cassette manually produced by serving a modified XML feed
    it 'polls the most recent jobs, parses them correctly and saves a Log' do
      expect { poller.perform }.to(
        change(JobPosting, :count).by(20).and(
          change(Address, :count).by(20).and(
            change(JobPostingApi::PollLog, :count).by(1)
          )
        )
      )

      expect(JobPostingApi::PollLog.last).to be_success

      expect(JobPosting.all).to include(
        have_attributes(
          title: 'Assistent Betreuung',
          description: be_a(ActionText::RichText).and(be_present),
          publication_date: eq(Date.new(2021, 9, 14)),
          icon_url: be_a(String).and(be_present),
          required_skills: be_a(ActionText::RichText).and(be_present),
          preferred_skills: be_a(ActionText::RichText).and(be_present),
          canton: 'SO',
          identification_number: 94_796,
          category: 'social_welfare',
          sub_category: be_nil,
          language: 'german',
          organization_name: 'Cutohof',
          minimum_service_months: 3,
          contact_information: be_a(String).and(be_present),
          address: have_attributes(
            primary_line: 'Cutohof',
            secondary_line: be_nil,
            street: 'Dorfstrasse 1',
            city: 'Kyburg-Buchegg',
            zip: 4586,
            latitude: be_within(1e-4).of(7.50584196262306),
            longitude: be_within(1e-4).of(47.14141245)
          )
        ),
        have_attributes(title: 'Waldpflege', organization_name: 'Talbetrieb Biohof Saum')
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it 'parses relations correctly' do
      poller.perform
      job_posting = JobPosting.find_by(identification_number: 80_443)
      expect(job_posting.workshops).to contain_exactly workshop
      expect(job_posting.organization).to be_nil
      expect(job_posting.address).to be_present
      expect(job_posting.available_service_periods).to(
        contain_exactly(have_attributes(beginning: Date.new(2021, 9, 14), ending: Date.new(2023, 9, 17)))
      )
    end

    context 'when an imported job posting is invalid' do
      let(:poll_log) { JobPostingApi::PollLog.last }

      # Manually inserted an invalid job posting in cassette
      it 'processes the valid postings and reports the invalid' do
        expect { poller.perform }.to(change(JobPosting, :count).by(19))

        expect(poll_log).to be_error
        expect(poll_log.log['error_count']).to eq 1
        expect(poll_log.log['failed_imports']).to(
          contain_exactly({ 'errors' => be_a(Hash), 'attributes' => be_a(Hash) })
        )
      end
    end

    context 'when a fetched job with the same identification number already exists' do
      let!(:job_posting) { create(:job_posting, :with_address, identification_number: 80_443) }

      it 'merges existing job postings and updates them' do
        expect { poller.perform }.to(
          change(JobPosting, :count).by(19).and(change(Address, :count).by(19)).and(
            change { job_posting.reload.slice(:description, :icon_url, :organization_name, :publication_date) }
          ).and(
            change { job_posting.address.reload.slice(:primary_line, :street, :zip, :city, :latitude, :longitude) }
          )
        )
      end

      context 'when the job posting has been claimed by an organization' do
        let(:organization) { create(:organization, :with_admin) }
        let(:job_posting) { create(:job_posting, identification_number: 80_443, organization: organization) }

        it 'does not update the job posting' do
          expect { poller.perform }.not_to(change { job_posting.reload.attributes })
        end

        it 'does not update the address' do
          expect { poller.perform }.not_to(change { job_posting.reload.address })
        end
      end

      context 'when the job posting already has workshops assigned' do
        let(:old_workshop) { create(:workshop) }
        let(:job_posting) { create(:job_posting, identification_number: 80_443, workshops: [old_workshop]) }

        it 'replaces existing required workshops with the updated workshops' do
          expect { poller.perform }.to(
            change { job_posting.reload.required_workshops }.to(
              contain_exactly(workshop)
            )
          )
        end
      end

      context 'when the job posting already has available service periods assigned' do
        let(:old_available_service_period) { build(:available_service_period) }
        let(:job_posting) do
          create(:job_posting, identification_number: 80_443, available_service_periods: [old_available_service_period])
        end

        it 'replaces existing required available_service_periods with the updated available_service_periods' do
          expect { poller.perform }.to(
            change { job_posting.reload.available_service_periods }.to(
              contain_exactly(have_attributes(beginning: Date.new(2021, 9, 14), ending: Date.new(2023, 9, 17)))
            )
          )
        end
      end
    end
  end
end
