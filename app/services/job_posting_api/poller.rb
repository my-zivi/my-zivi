# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module JobPostingApi
  class Poller
    JOB_ITEM_XPATH = '//item'
    FEED_URL = ENV['JOB_POSTINGS_FEED_URL']
    DEFAULT_ATTRIBUTES = {
      icon_url: 'https://i.picsum.photos/id/458/40/40.jpg?hmac=QK8u-TtdS_88CLa_qvzYyB9aZ6akNFET2fE50QihRUw',
      contact_information: <<~TEXT.squish
        Dieser Betrieb ist noch nicht bei MyZivi registriert.
        Bitte bewerbe Dich im EZIVI.
      TEXT
    }.freeze

    def initialize
      @errored_job_postings = []
    end

    def perform
      URI.parse(FEED_URL).open do |page|
        feed = Nokogiri::XML(page, &:noblanks)
        process_feed(feed)
      end

      log_result!
    end

    private

    def log_result!
      status = @errored_job_postings.empty? ? :success : :error
      PollLog.create!(log: JSON.dump(error_report), status: PollLog.statuses[status])
    end

    def error_report
      return {} if @errored_job_postings.empty?

      @errored_job_postings.map do |job_posting|
        {
          errors: job_posting.errors.messages,
          attributes: job_posting.attributes
        }
      end
    end

    def process_feed(feed)
      feed.xpath(JOB_ITEM_XPATH).map do |job_xml|
        sync_posting(Parser.parse_job_posting_attributes(job_xml))
      end
    end

    def sync_posting(attributes)
      JobPosting.find_or_create_by(identification_number: attributes[:identification_number]).tap do |job_posting|
        job_posting.assign_attributes(attributes.merge(**DEFAULT_ATTRIBUTES))
        register_job_posting_error(job_posting) unless job_posting.valid?
        job_posting.save
      end
    end

    def register_job_posting_error(job_posting)
      @errored_job_postings << job_posting
    end
  end
end
