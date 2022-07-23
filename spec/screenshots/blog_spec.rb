# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blog screenshots', type: :system, js: true do
  before { create_list(:blog_entry, 4, created_at: Date.new(2020, 1, 1), author: 'Max Mustermann') }

  it 'renders blog page correctly' do
    visit blog_entries_path
    page.percy_snapshot(page, { name: 'Blog Index' })

    visit blog_entry_path(BlogEntry.order(:title).first)
    page.percy_snapshot(page, { name: 'Blog Entry' })
  end
end
