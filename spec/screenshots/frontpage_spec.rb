# frozen_string_literal: true

require 'rails_helper'
require 'percy'

RSpec.describe 'Frontpage screenshots', type: :system, js: true do
  before { create_list(:job_posting, 4, publication_date: Date.new(2020, 1, 1)) }

  it 'renders front page correctly' do
    visit root_path
    Percy.snapshot(page, { name: 'Frontpage' })
  end
end
