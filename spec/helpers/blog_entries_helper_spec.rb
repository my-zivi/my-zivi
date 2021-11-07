# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogEntriesHelper, type: :helper do
  describe '#tags_filter_menu_items' do
    subject(:menu_items) { Nokogiri::HTML(helper.tags_filter_menu_items(filter_params)) }

    let(:filter_params) { { tags: %w[article] } }
    let(:dropdown_links) do
      menu_items.css('.dropdown-item').map { |dropdown_item| CGI.unescape(dropdown_item.attr('href')) }
    end

    before do
      params.merge!(controller: 'blog_entries', action: 'index')
    end

    it 'generates dropdown menu items for all supported tags' do
      remaining_tags = BlogEntry::SUPPORTED_TAGS - ['article']
      expect(dropdown_links).to contain_exactly(
        '/blog?filter[tags][]=',
        *(remaining_tags.map { |tag| "/blog?filter[tags][]=article&filter[tags][]=#{tag}" })
      )
    end

    context 'when no filter params are given' do
      let(:filter_params) { { tags: [] } }

      it 'generates dropdown items for all supported tags' do
        expect(dropdown_links).to contain_exactly(
          *(BlogEntry::SUPPORTED_TAGS.map { |tag| "/blog?filter[tags][]=#{tag}" })
        )
      end
    end

    context 'when multiple filters are already present' do
      let(:filter_params) { { tags: %w[article news] } }

      it 'generates correct dropdown items' do
        expect(dropdown_links).to contain_exactly(
          '/blog?filter[tags][]=news',
          '/blog?filter[tags][]=article',
          '/blog?filter[tags][]=article&filter[tags][]=news&filter[tags][]=podcast'
        )
      end
    end
  end
end
