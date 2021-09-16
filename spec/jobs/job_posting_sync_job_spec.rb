# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingSyncJob, type: :job do
  describe '#perform' do
    let(:deactivated_postings_poller) { instance_double('JobPostingApi::DeactivatedJobPostingsPoller', perform: true) }
    let(:current_postings_poller) do
      instance_double('JobPostingApi::CurrentJobPostingsPoller', perform: [build(:job_posting)])
    end

    before do
      allow(JobPostingApi::CurrentJobPostingsPoller).to receive(:new).and_return current_postings_poller
      allow(JobPostingApi::DeactivatedJobPostingsPoller).to receive(:new).and_return deactivated_postings_poller
      allow(JobPosting).to receive(:reindex!)
    end

    it 'calls sync and deactivated service' do
      described_class.new.perform
      expect(JobPosting).to have_received(:reindex!)
      expect(current_postings_poller).to have_received(:perform)
      expect(deactivated_postings_poller).to have_received(:perform)
    end
  end
end
