# frozen_string_literal: true

require 'sitemap_generator/my_zivi_google_storage_adapter'

SitemapGenerator::Sitemap.default_host = "https://#{ENV['APP_HOST']}"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::MyZiviGoogleStorageAdapter.new

STATIC_PAGES = [
  new_user_session_path,
  new_user_registration_path,
  for_organizations_path,
  administration_path,
  recruiting_path,
  about_us_path,
  agb_path,
  privacy_policy_path,
  job_postings_path,
  blog_entries_path
].freeze

SitemapGenerator::Sitemap.create do
  STATIC_PAGES.each { |path| add path }

  JobPosting.find_each do |job_posting|
    add job_posting_path(job_posting), lastmod: job_posting.updated_at, priority: 0.7
  end

  BlogEntry.find_each do |blog_entry|
    add blog_entry_path(blog_entry),
        lastmod: blog_entry.updated_at,
        priority: 0.6,
        news: {
          publication_name: I18n.t('my_zivi'),
          publication_language: 'de',
          title: blog_entry.title,
          publication_date: blog_entry.created_at.to_date.iso8601
        }
  end
end

SitemapGenerator::Sitemap.ping_search_engines(ENV['SITEMAP_PUBLIC_URL']) if ENV['SITEMAP_PUBLIC_URL'].present?
