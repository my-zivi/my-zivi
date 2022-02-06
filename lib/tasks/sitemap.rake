# frozen_string_literal: true

Rake::Task['sitemap:refresh'].clear
Rake::Task['sitemap:refresh:no_ping'].clear

namespace :sitemap do
  desc 'Refreshes the sitemap and pings search engines'
  task refresh: :environment do
    if ENV['SITEMAP_ENABLED'] == 'true'
      require 'sitemap_generator/my_zivi_sitemap'

      SitemapGenerator::MyZiviSitemap.generate
    else
      puts 'Sitemap not enabled'
    end
  end

  desc 'Generate sitemaps but don\'t ping search engines.'
  task 'refresh:no_ping': :environment do
    if ENV['SITEMAP_ENABLED'] == 'true'
      require 'sitemap_generator/my_zivi_sitemap'

      SitemapGenerator::MyZiviSitemap.generate(ping_search_engines: false)
    else
      puts 'Sitemap not enabled'
    end
  end
end
