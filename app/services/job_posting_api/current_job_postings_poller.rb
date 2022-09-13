# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module JobPostingApi
  class CurrentJobPostingsPoller
    JOB_POSTING_XPATH = '//job_posting'
    DEFAULT_ATTRIBUTES = {
      contact_information: <<~TEXT.squish
        Dieser Betrieb ist noch nicht bei MyZivi registriert.
        Bitte bewerbe Dich im EZIVI.
      TEXT
    }.freeze

    def initialize
      @errored_job_postings = []
    end

    def perform
      URI.parse(ENV['CURRENT_JOB_POSTINGS_API_URL']).open do |page|
        feed = JSON.parse(page.read, symbolize_names: true)
        process_feed(feed)
      end

      log_result!
    end

    private

    def log_result!
      status = @errored_job_postings.empty? ? :success : :error
      PollLog.create!(log: error_report, status: PollLog.statuses[status])
    end

    def error_report
      return { error_count: 0 } if @errored_job_postings.empty?

      {
        error_count: @errored_job_postings.length,
        failed_imports: @errored_job_postings.map do |job_posting|
          {
            errors: job_posting.errors,
            attributes: job_posting.attributes
          }
        end
      }
    end

    def process_feed(feed)
      feed.map do |job_hash|
        attributes = Parser.parse_job_posting_attributes(job_hash)
        job_posting = JobPosting.find_or_initialize_by(identification_number: attributes[:identification_number])
        sync_posting(job_posting, attributes) if job_posting.scraped?
      end
    end

    # :reek:FeatureEnvy
    def sync_posting(job_posting, attributes)
      enhanced_attributes = attributes.merge(**DEFAULT_ATTRIBUTES)
      enhanced_attributes[:address_attributes][:id] = job_posting.address_id if job_posting.address.present?

      job_posting.assign_attributes(enhanced_attributes)
      return register_job_posting_error(job_posting) unless job_posting.valid?

      persist_job_posting(job_posting)
    end

    def persist_job_posting(job_posting)
      JobPosting.transaction do
        job_posting.available_service_periods.select(&:persisted?).each(&:destroy)
        job_posting.job_posting_workshops.select(&:persisted?).each(&:destroy)
        job_posting.save!
      end
    end

    def register_job_posting_error(job_posting)
      @errored_job_postings << job_posting
    end
  end
end
