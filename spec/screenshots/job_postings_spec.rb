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

  it 'renders inquiry form correctly' do
    visit job_posting_path(job_posting)
    click_button I18n.t('job_postings.show.apply_via_myzivi')
    fill_in 'service_inquiry[service_beginning]', with: 4.months.from_now.to_date.iso8601
    fill_in 'service_inquiry[service_ending]', with: Time.zone.today.to_date.iso8601
    click_button I18n.t('service_inquiries.new.submit')
    expect(page).to have_content(I18n.t('activerecord.errors.models.service_inquiry.attributes.service_ending.after'))
    Percy.snapshot(page, { name: 'Service Inquiry Form' })
  end
end
