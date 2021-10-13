# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobPostingsHelper, type: :helper do
  describe '#job_posting_category_icon' do
    JobPosting.categories.values.map(&:to_sym).each do |category|
      it "generates an icon for #{category}" do
        expect(helper.job_posting_category_icon(build(:job_posting, category: category))).to match(/fa. fa-.+/)
      end
    end
  end

  describe '#google_maps_link' do
    subject(:link) { helper.google_maps_link(job_posting) }

    let(:job_posting) { build(:job_posting, :with_address) }

    it 'renders link' do
      expect(link).to eq <<~HTML.squish.gsub(/> </, '><')
        <a target="_blank"
           rel="noreferrer nofollow noopener"
           href="https://www.google.com/maps/search/?api=1&amp;query=47.388319,8.483761">
          <div class="d-inline-flex">MyCompany<i class="fas fa-external-link-alt ml-1"></i></div>
        </a>
      HTML
    end
  end
end
