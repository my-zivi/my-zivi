# frozen_string_literal: true

# :nocov:
require 'google/cloud/storage'

module SitemapGenerator
  class MyZiviGoogleStorageAdapter
    def initialize(opts = {})
      ENV['GOOGLE_CLOUD_CREDENTIALS'] ||= Rails.application.credentials[:gcs_credentials].as_json

      opts = {
        project_id: ENV['GCS_PROJECT_NAME'],
        bucket: ENV['GCS_BUCKET_NAME']
      }.merge(opts)

      @bucket = opts.delete(:bucket)
      @storage_options = opts
    end

    def write(location, raw_data)
      if ENV['SITEMAP_ENABLED'] == 'true' && ENV['GCS_PROJECT_NAME'].present? && ENV['GCS_BUCKET_NAME'].present?
        # rubocop:disable Rails/Output
        puts 'Uploading to Google Cloud…'
        # rubocop:enable Rails/Output
        upload(location, raw_data)
      else
        warn '`SITEMAP_ENABLED` is not set to true or Google Cloud setup is incorrect…'
        warn 'writing to file system instead'
        write_to_filesystem(location, raw_data)
      end
    end

    private

    def write_to_filesystem(location, raw_data)
      SitemapGenerator::FileAdapter.new.write(location, raw_data)
    end

    def upload(location, raw_data)
      write_to_filesystem(location, raw_data)

      storage = Google::Cloud::Storage.new(**@storage_options)
      bucket = storage.bucket(@bucket)
      bucket.create_file(location.path, location.path_in_public, acl: 'public')
    end
  end
end
# :nocov:
