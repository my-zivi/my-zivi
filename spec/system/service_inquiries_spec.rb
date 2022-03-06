# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Service Inquiries', type: :system, js: true do
  let(:job_posting) { create(:job_posting) }

  before do
    visit job_posting_path(job_posting)
  end

  it 'a civil servant can submit a service inquiry' do
    click_button I18n.t('job_postings.show.apply_via_myzivi')
    fill_in 'service_inquiry[name]', with: 'Peter Parker'
    fill_in 'service_inquiry[email]', with: 'peter@example.com'
    fill_in 'service_inquiry[service_beginning]', with: 1.month.from_now.to_date.iso8601
    fill_in 'service_inquiry[service_duration]', with: '1 Monat'
    fill_in 'service_inquiry[message]', with: 'Hallo!'
    expect do
      click_button I18n.t('service_inquiries.new.submit')
      expect(page).to have_content I18n.t('service_inquiries.create.title')
    end.to change(ServiceInquiry, :count)

    click_button I18n.t('close')
    expect(page).not_to have_content I18n.t('service_inquiries.create.title')
  end

  it 'a civil servant cannot submit invalid inquiry data' do
    click_button I18n.t('job_postings.show.apply_via_myzivi')
    fill_in 'service_inquiry[name]', with: 'Peter Parker'
    fill_in 'service_inquiry[email]', with: 'peter@example.com'
    fill_in 'service_inquiry[service_beginning]', with: 4.months.from_now.to_date.iso8601
    fill_in 'service_inquiry[message]', with: 'Hallo!'
    expect do
      click_button I18n.t('service_inquiries.new.submit')
      expect(page).to have_content I18n.t('errors.messages.blank')
    end.not_to change(ServiceInquiry, :count)
  end
end
