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
end
