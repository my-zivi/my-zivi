# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingsController do
  describe '#index' do
    let(:path) { job_postings_path }

    it 'uses german locale' do
      I18n.with_locale(:'fr-CH') do
        expect { get path }.to(change(I18n, :locale).to(:'de-CH'))
      end
    end

    it 'returns http success' do
      get path
      expect(response).to have_http_status(:success)
      expect(response.body).not_to be_empty
    end
  end

  describe '#show' do
    let(:job_posting) { create(:job_posting) }

    it 'returns http success' do
      get job_posting_path(job_posting)
      expect(response).to have_http_status(:success)
      expect(response.body).to include job_posting.title, job_posting.organization_display_name
    end

    context 'when job posting has not yet been published' do
      let(:job_posting) { create(:job_posting, published: false) }

      it 'raises a not found error' do
        expect { get job_posting_path(job_posting) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
