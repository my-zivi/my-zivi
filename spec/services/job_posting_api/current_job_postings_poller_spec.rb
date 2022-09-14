# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingApi::CurrentJobPostingsPoller, :vcr do
  around do |spec|
    envs = {
      CURRENT_JOB_POSTINGS_API_URL: 'https://scraper.myzivi.ch/dev/current_postings.json',
      APP_HOST: 'myzivi.ch'
    }

    ClimateControl.modify(envs) { spec.run }
  end

  describe '#perform' do
    subject(:poller) { described_class.new }

    let!(:workshop) { create(:workshop, name: 'Umwelt- & Naturschutz') }

    # rubocop:disable RSpec/ExampleLength
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
          title: 'Hilfsbetreuer',
          description: be_a(ActionText::RichText).and(be_present),
          publication_date: eq(Date.new(2022, 9, 14)),
          icon_url: be_a(String).and(be_present),
          required_skills: be_a(ActionText::RichText).and(be_present),
          preferred_skills: be_a(ActionText::RichText).and(be_present),
          canton: 'LU',
          identification_number: 18_470,
          category: 'social_welfare',
          sub_category: 'support_and_accompaniment',
          language: 'german',
          organization_name: 'CASA FARFALLA',
          minimum_service_months: 1,
          contact_information: be_a(String).and(be_present),
          last_found_at: eq(Date.new(2022, 9, 14)),
          address: have_attributes(
            primary_line: 'CASA FARFALLA',
            secondary_line: be_nil,
            street: 'Erlenstrasse 23',
            city: 'Emmenbrücke',
            zip: 6020,
            longitude: be_within(1e-4).of(8.26958010337137),
            latitude: be_within(1e-4).of(47.07833455)
          ),
          weekly_work_time: 42,
          fixed_work_time: true,
          good_reputation: false,
          e_government: true,
          work_on_weekend: true,
          work_night_shift: false,
          accommodation_provided: true,
          food_provided: true
        ),
        have_attributes(title: 'Spielplatzbetreuer', organization_name: 'Spielplatz Längmuur')
      )
    end

    it 'parses relations correctly' do
      poller.perform
      job_posting = JobPosting.find_by(identification_number: 18_938)
      expect(job_posting.workshops).to contain_exactly(workshop)
      expect(job_posting.organization).to be_nil
      expect(job_posting.address).to be_present
      expect(job_posting.available_service_periods).to(
        contain_exactly(have_attributes(beginning: Date.new(2023, 1, 2), ending: Date.new(2024, 5, 26)))
      )
    end
    # rubocop:enable RSpec/ExampleLength

    context 'when an imported job posting is invalid' do
      let(:poll_log) { JobPostingApi::PollLog.last }

      # Manually inserted an invalid job posting in cassette
      it 'processes the valid postings and reports the invalid' do
        expect { poller.perform }.to(change(JobPosting, :count).by(17))

        expect(poll_log).to be_error
        expect(poll_log.log['error_count']).to eq 3
        expect(poll_log.log['failed_imports']).to(
          include(
            { 'errors' => be_a(Hash), 'attributes' => be_a(Hash) }
          ).exactly(3).times
        )
      end
    end

    context 'when a fetched job with the same identification number already exists' do
      let!(:job_posting) { create(:job_posting, :with_address, identification_number: 18_470) }

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
        let(:job_posting) { create(:job_posting, identification_number: 18_938, workshops: [old_workshop]) }

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
          create(:job_posting, identification_number: 18_938, available_service_periods: [old_available_service_period])
        end

        it 'replaces existing required available_service_periods with the updated available_service_periods' do
          expect { poller.perform }.to(
            change { job_posting.reload.available_service_periods }.to(
              contain_exactly(have_attributes(beginning: Date.new(2023, 1, 2), ending: Date.new(2024, 5, 26)))
            )
          )
        end
      end
    end
  end
end
