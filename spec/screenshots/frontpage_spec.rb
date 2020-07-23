# frozen_string_literal: true

require 'rails_helper'
require 'percy'

RSpec.describe 'Frontpage screenshots', type: :system, js: true do
  it 'renders front page correctly' do
    visit root_path
    Percy.snapshot(page, { name: 'Frontpage' })
  end
end
