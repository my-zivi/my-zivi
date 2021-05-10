# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogEntriesController, type: :request do
  subject { response }

  describe '#index' do
    let!(:blog_entries) { create_pair(:blog_entry) }

    before { get blog_entries_path }

    it 'renders the blog entries' do
      expect(response).to be_successful
      expect(response.body).to include(
        blog_entries.first.title,
        blog_entries.second.title,
        blog_entries.first.author,
        blog_entries.second.author,
        blog_entries.first.slug,
        blog_entries.second.slug
      )
    end
  end

  describe '#show' do
    let!(:blog_entry) { create(:blog_entry, subtitle: 'My subtitle', created_at: Date.new(2020, 2, 5)) }

    before { get blog_entry_path(blog_entry) }

    it 'renders the blog entry' do
      expect(response).to be_successful
      expect(response.body).to include(
        blog_entry.title,
        blog_entry.subtitle,
        I18n.t('written_by', author: blog_entry.author, date: '05.02.20'),
        blog_entry.content.to_plain_text
      )
    end
  end
end
