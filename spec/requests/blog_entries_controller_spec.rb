# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogEntriesController, type: :request do
  subject { response }

  describe '#index' do
    let!(:blog_entries) { create_pair(:blog_entry) }
    let!(:hidden_blog_entry) { create(:blog_entry, published: false) }
    let!(:podcast_blog_entry) { create(:blog_entry, tags: %w[podcast]) }

    context 'when no filter params are set' do
      before { get blog_entries_path }

      it 'renders all the public blog entries' do
        expect(response).to be_successful
        expect(response.body).to include(
          blog_entries.first.title,
          blog_entries.second.title,
          blog_entries.first.author,
          blog_entries.second.author,
          blog_entries.first.slug,
          blog_entries.second.slug,
          podcast_blog_entry.title
        )
        expect(response.body).not_to include(hidden_blog_entry.title)
      end
    end

    context 'when filtering for podcast tag only' do
      before { get blog_entries_path(params: { filter: { tags: %w[podcast] } }) }

      it 'only renders blog entries with the podcast tag' do
        expect(response.body).to include(podcast_blog_entry.title)
        blog_entries.each { |entry| expect(response.body).not_to include(entry.title) }
      end
    end

    context 'when filtering for article tag only' do
      before { get blog_entries_path(params: { filter: { tags: %w[article] } }) }

      it 'only renders blog entries with the podcast tag' do
        expect(response.body).not_to include(podcast_blog_entry.title)
        blog_entries.each { |entry| expect(response.body).to include(entry.title) }
      end
    end

    context 'when filtering for article and podcast tags only' do
      before { get blog_entries_path(params: { filter: { tags: %w[article podcast] } }) }

      it 'only renders blog entries with the podcast tag' do
        expect(response.body).to include(podcast_blog_entry.title)
        blog_entries.each { |entry| expect(response.body).to include(entry.title) }
      end
    end
  end

  describe '#show' do
    let(:perform_request) { get blog_entry_path(blog_entry) }
    let!(:blog_entry) { create(:blog_entry, subtitle: 'My subtitle', created_at: Date.new(2020, 2, 5)) }

    it 'renders the blog entry' do
      perform_request
      expect(response).to be_successful
      expect(response.body).to include(
        blog_entry.title,
        blog_entry.subtitle,
        I18n.t('blog_entries.show.written_by', author: blog_entry.author, date: '05.02.20'),
        blog_entry.content.to_plain_text
      )
    end

    context 'when blog entry is not published' do
      let(:blog_entry) { create(:blog_entry, published: false) }

      it 'raises record not found exception' do
        expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
