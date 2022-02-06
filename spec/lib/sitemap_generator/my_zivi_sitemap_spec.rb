# frozen_string_literal: true

require 'rails_helper'
require 'sitemap_generator/my_zivi_sitemap'

RSpec.describe SitemapGenerator::MyZiviSitemap do
  describe '.generate' do
    let(:sitemap_location) { Rails.root.join('tmp/sitemaps/sitemap.xml') }
    let!(:published_job_posting) { create(:job_posting, published: true) }
    let!(:published_blog_entry) { create(:blog_entry, published: true) }
    let!(:unpublished_job_posting) { create(:job_posting, published: false) }
    let!(:unpublished_blog_entry) { create(:blog_entry, published: false) }

    before do
      stub_const('ENV', ENV.to_h.with_indifferent_access.merge(
                          SITEMAP_PUBLIC_URL: 'https://example.com/mymap.xml',
                          SITEMAP_ENABLED: 'false' # prevent upload to GCS
                        ))
      allow(SitemapGenerator::Sitemap).to receive(:ping_search_engines).and_return true
      allow(SitemapGenerator::Sitemap).to receive(:create).and_call_original
    end

    after { File.delete(sitemap_location) }

    it 'generates the sitemap and pings search engines' do
      described_class.generate
      expect(SitemapGenerator::Sitemap).to have_received(:create)
      expect(SitemapGenerator::Sitemap).to(
        have_received(:ping_search_engines).with('https://example.com/mymap.xml')
      )
      expect(File.exist?(sitemap_location)).to eq true
    end

    describe 'generated links' do
      subject(:sitemap) { File.read(sitemap_location) }

      before { described_class.generate }

      it 'contains published paths' do
        expect(sitemap).to include(
          Rails.application.routes.url_helpers.job_posting_path(published_job_posting),
          Rails.application.routes.url_helpers.blog_entry_path(published_blog_entry)
        )

        expect(sitemap).not_to include(
          Rails.application.routes.url_helpers.job_posting_path(unpublished_job_posting),
          Rails.application.routes.url_helpers.blog_entry_path(unpublished_blog_entry)
        )
      end
    end

    context 'when ping_search_engines is set to false' do
      it 'creates a sitemap but does not ping search engines' do
        described_class.generate(ping_search_engines: false)
        expect(SitemapGenerator::Sitemap).not_to(have_received(:ping_search_engines))
        expect(SitemapGenerator::Sitemap).to have_received(:create)
        expect(File.exist?(sitemap_location)).to eq true
      end
    end
  end
end
