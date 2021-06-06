# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingPollJob, type: :job do
  describe '#perform' do
    let(:poller) { instance_double('JobPostingApi::Poller', perform: [build(:job_posting)]) }

    before do
      allow(JobPostingApi::Poller).to receive(:new).and_return poller
    end

    it 'calls polling service' do
      expect(described_class.new.perform).to contain_exactly be_an_instance_of(JobPosting)
    end
  end
end
