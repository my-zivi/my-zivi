# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingApi::DeactivatedJobPostingsPoller do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    let(:api_url) { 'https://scraper.myzivi.ch' }

    describe 'api request' do
      around do |spec|
        ClimateControl.modify(JOB_POSTINGS_API_URL: api_url, APP_HOST: 'myzivi.ch') do
          spec.run
        end
      end

      it 'sends a request to the api and processes the response', :vcr do
        expect { perform }.not_to raise_error
      end
    end

    describe 'job posting deactivation' do
      let!(:job_posting) { create(:job_posting, published: true) }
      let(:returned_json) do
        {
          status: 'ok',
          deleted: [job_posting.identification_number, job_posting.identification_number + 12]
        }
      end

      before { WebMock.stub_request(:get, "#{api_url}/deleted.json").to_return(body: returned_json.to_json) }

      after { WebMock.reset! }

      it 'deactivates the deleted job postings' do
        expect { perform }.to(change { job_posting.reload.published }.from(true).to(false))
      end

      context 'when the job posting is claimed' do
        let(:job_posting) { create(:job_posting, :claimed_by_organization, published: true) }

        it 'does not deactivate the posting' do
          expect { perform }.not_to(change { job_posting.reload.published })
        end
      end

      context 'when the server returns no deleted job postings' do
        let(:returned_json) { { status: 'ok', deleted: [] } }

        it 'does nothing' do
          expect { perform }.not_to(change(job_posting, :reload))
        end
      end

      context 'when the server returns a non-success status' do
        let(:returned_json) { { status: 'error', deleted: [] } }

        it 'raises an api error' do
          expect { perform }.to raise_error(JobPostingApi::ApiError, /API returned error status/)
        end
      end

      context 'when the server returns non 2xx status code' do
        before { WebMock.stub_request(:get, "#{api_url}/deleted.json").to_return(body: '', status: 404) }

        it 'raises an api error' do
          expect { perform }.to raise_error(JobPostingApi::ApiError, 'API returned non-200 status code') do |error|
            expect(error.sentry_context).to include(extra: include(response: be_a(Net::HTTPResponse)))
          end
        end
      end
    end
  end
end
