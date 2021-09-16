# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingSyncJob, type: :job do
  describe '#perform' do
    let(:poller) { instance_double('JobPostingApi::Poller', perform: [build(:job_posting)]) }

    before do
      allow(JobPostingApi::CurrentJobPostingsPoller).to receive(:new).and_return poller
      allow(JobPosting).to receive(:reindex!)
    end

    it 'calls polling service' do
      described_class.new.perform
      expect(JobPosting).to have_received(:reindex!)
      expect(poller).to have_received(:perform)
    end
  end
end
