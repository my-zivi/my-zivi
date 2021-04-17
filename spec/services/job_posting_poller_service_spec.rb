# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingPollerService, :vcr do
  describe '.poll' do
    subject(:polled_postings) { described_class.poll }

    # casette manually edited
    it 'polls the most recent jobs' do
      expect { polled_postings }.to change(JobPosting, :count).by(2)

      expect(polled_postings).to contain_exactly(
        have_attributes(title: 'Naturschutzeinsatz'),
        have_attributes(title: 'Landschaftspflege')
      )
    end

    context 'when a fetched job with the same link already exists' do
      let!(:job_posting) { create(:job_posting, link: 'https://www.myzivi.ch/job/70/naturschutzeinsatz/') }

      it 'merges existing job postings and updates them' do
        expect { polled_postings }.to(
          change(JobPosting, :count).by(1).and(
            change { job_posting.reload.description }
          )
        )
      end
    end
  end
end
