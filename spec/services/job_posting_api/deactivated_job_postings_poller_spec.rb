# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingApi::DeactivatedJobPostingsPoller do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    around do |spec|
      travel_to Time.zone.local(2022, 9, 13, 9, 0, 0) do
        spec.run
      end
    end

    describe 'job posting deactivation and reactivation' do
      let!(:old_published_job_posting) { create(:job_posting, published: true, last_found_at: 5.months.ago) }
      let!(:new_unpublished_job_posting) { create(:job_posting, published: false, last_found_at: 2.days.ago) }
      let!(:new_published_job_posting) { create(:job_posting, published: true, last_found_at: 2.days.ago) }
      let!(:old_unpublished_job_posting) { create(:job_posting, published: false, last_found_at: 5.months.ago) }

      it 'deactivates the deleted job postings' do
        expect { perform }.to(change { old_published_job_posting.reload.published }.from(true).to(false))
      end

      it 'reactivates the deleted job postings' do
        expect { perform }.to(change { new_unpublished_job_posting.reload.published }.from(false).to(true))
      end

      it 'does not change correctly published job posting' do
        expect { perform }.not_to(change { new_published_job_posting.reload.published })
      end

      it 'does not change correctly unpublished job postings' do
        expect { perform }.not_to(change { old_unpublished_job_posting.reload.published })
      end

      context 'when the unpublished job posting is claimed' do
        let(:unpublished_job_posting) do
          create(:job_posting, :claimed_by_organization, published: false, last_found_at: 1.day.ago)
        end

        it 'does not reactivate the posting' do
          expect { perform }.not_to(change { unpublished_job_posting.reload.published })
        end
      end

      context 'when the published job posting is claimed' do
        let(:job_posting) do
          create(:job_posting, :claimed_by_organization, published: true, last_found_at: 5.months.ago)
        end

        it 'does not deactivate the posting' do
          expect { perform }.not_to(change { job_posting.reload.published })
        end
      end
    end
  end
end
