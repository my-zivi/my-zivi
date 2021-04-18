# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingPollJob, type: :job do
  describe '#perform' do
    before do
      allow(JobPostingPollerService).to receive(:poll).and_return [build(:job_posting)]
    end

    it 'calls polling service' do
      expect(described_class.new.perform).to contain_exactly be_an_instance_of(JobPosting)
    end
  end
end
