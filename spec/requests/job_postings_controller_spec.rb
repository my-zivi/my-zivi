# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingsController do
  describe '#index' do
    let(:path) { job_postings_path }

    around do |spec|
      I18n.locale.yield_self do |default_locale|
        spec.run
        I18n.locale = default_locale
      end
    end

    it 'uses german locale' do
      I18n.locale = :'fr-CH'
      expect { get path }.to(change(I18n, :locale).to(:'de-CH'))
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
  end
end
