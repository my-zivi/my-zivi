# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingApi::Poller, :vcr do
  around do |spec|
    ClimateControl.modify(JOB_POSTINGS_FEED_URL: 'http://scraper.example.com/xml.rss') do
      spec.run
    end
  end

  describe '#perform' do
    subject(:poller) { described_class.new }

    let!(:workshop) { create(:workshop, name: 'Umwelt- und Naturschutz') }

    # rubocop:disable RSpec/ExampleLength
    # cassette manually produced by serving a modified XML feed
    it 'polls the most recent jobs, parses them correctly and saves a Log' do
      expect { poller.perform }.to(
        change(JobPosting, :count).by(2).and(
          change(JobPostingApi::PollLog, :count).by(1)
        )
      )

      expect(JobPostingApi::PollLog.last).to be_success

      expect(JobPosting.all).to contain_exactly(
        have_attributes(
          title: 'Naturschutzeinsatz',
          description: be_a(String).and(be_present),
          publication_date: eq(Date.new(2021, 6, 6)),
          icon_url: be_a(String).and(be_present),
          required_skills: be_a(String).and(be_present),
          preferred_skills: be_a(String).and(be_present),
          canton: 'BE',
          identification_number: 89_117,
          category: 'agriculture',
          sub_category: be_nil,
          language: 'german',
          organization_name: 'Talbetrieb Hattenbühl',
          minimum_service_months: 1,
          contact_information: be_a(String).and(be_present)
        ),
        have_attributes(title: 'Landschaftspflege', organization_name: 'Talbetrieb Brügger Peter')
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it 'parses relations correctly' do
      poller.perform
      job_posting = JobPosting.find_by(identification_number: 89_117)
      expect(job_posting.workshops).to contain_exactly workshop
      expect(job_posting.organization).to be_nil
      expect(job_posting.available_service_periods).to(
        contain_exactly(have_attributes(beginning: Date.new(2021, 6, 6), ending: Date.new(2023, 6, 11)))
      )
    end

    context 'when an imported job posting is invalid' do
      let(:poll_log) { JobPostingApi::PollLog.last }

      it 'processes the valid postings and reports the invalid' do
        expect { poller.perform }.to(change(JobPosting, :count).by(1))

        expect(poll_log).to be_error
        expect(poll_log.log['error_count']).to eq 1
        expect(poll_log.log['failed_imports']).to(
          contain_exactly({ 'errors' => be_a(Hash), 'attributes' => be_a(Hash) })
        )
      end
    end

    context 'when a fetched job with the same identification number already exists' do
      let!(:job_posting) { create(:job_posting, identification_number: 89_117) }

      it 'merges existing job postings and updates them' do
        expect { poller.perform }.to(
          change(JobPosting, :count).by(1).and(
            change { job_posting.reload.slice(:description, :icon_url, :organization_name, :publication_date) }
          )
        )
      end

      context 'when the job posting already has workshops assigned' do
        let(:old_workshop) { create(:workshop) }
        let(:job_posting) { create(:job_posting, identification_number: 89_117, workshops: [old_workshop]) }

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
          create(:job_posting, identification_number: 89_117, available_service_periods: [old_available_service_period])
        end

        it 'replaces existing required available_service_periods with the updated available_service_periods' do
          expect { poller.perform }.to(
            change { job_posting.reload.available_service_periods }.to(
              contain_exactly(have_attributes(beginning: Date.new(2021, 6, 6), ending: Date.new(2023, 6, 11)))
            )
          )
        end
      end
    end
  end
end
