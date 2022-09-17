# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Searches', type: :system, js: true do
  before { page.driver.browser.manage.window.resize_to(1920, 1080) }

  describe 'map view' do
    it 'renders map view correctly', :aggregate_failures do
      visit job_postings_path
      find('button', text: 'Karte').click
      page.percy_snapshot(page, { name: 'Map View' })

      expect(page).to have_css('.leaflet-marker-icon')

      # wait for weird gray overlay to disappear (is not removed from DOM, so we cannot wait for it to be gone)
      sleep(0.15)

      page.percy_snapshot(page, { name: 'Map View' })
    end
  end

  describe 'grid view' do
    it 'renders grid view correctly' do
      visit job_postings_path
      expect(page).to have_css('.job-posting-card')
      page.percy_snapshot(page, { name: 'Grid View' })
      check I18n.t('activerecord.enums.job_posting.categories.social_welfare')
      expect(page).to have_content('8 Resultate gefunden')
      page.percy_snapshot(page, { name: 'Filtered Grid View' })
    end
  end
end
