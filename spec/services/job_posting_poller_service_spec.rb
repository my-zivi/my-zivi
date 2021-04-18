# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingPollerService, :vcr do
  around do |spec|
    ClimateControl.modify(SMARTJOBBOARD_PUBLIC_URL: 'https://www.myzivi.ch') do
      spec.run
    end
  end

  describe '.poll' do
    subject(:polled_postings) { described_class.poll }

    # cassette manually edited
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
            change { job_posting.reload.slice(:description, :icon_url, :company, :publication_date) }
          )
        )
      end
    end
  end
end
