# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage screenshots', type: :system, js: true do
  before { create_list(:job_posting, 4, publication_date: Date.new(2020, 1, 1)) }

  it 'renders front page correctly' do
    visit root_path
    page.percy_snapshot(page, { name: 'Frontpage' })
  end

  it 'renders pricing page correctly' do
    visit pricing_path
    page.percy_snapshot(page, { name: 'Pricing' })
  end
end
