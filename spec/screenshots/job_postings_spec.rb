# frozen_string_literal: true

require 'rails_helper'
require 'percy'

RSpec.describe 'Job Postings screenshots', type: :system, js: true do
  let!(:job_posting) do
    create(:job_posting, :with_workshops, :with_available_service_periods, identification_number: 1235)
  end

  it 'renders front page correctly' do
    visit job_posting_path(job_posting)
    Percy.snapshot(page, { name: 'Job Posting Detail View' })
  end
end
