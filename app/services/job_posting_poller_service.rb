# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class JobPostingPollerService
  class << self
    PATH = '/feeds/standard.xml'

    def poll
      URI.parse(url).open do |page|
        feed = Nokogiri::XML(page, &:noblanks)
        process_feed(feed)
      end
    end

    private

    def url
      "#{ENV['SMARTJOBBOARD_PUBLIC_URL']}#{PATH}"
    end

    def process_feed(feed)
      feed.xpath('//job').map do |job|
        sync_posting(
          title: job_field(job, 'title'),
          publication_date: Date.parse(job_field(job, 'date')),
          description: job_field(job, 'description'),
          link: job_field(job, 'applyurl'),
          icon_url: job_field(job, 'companylogo'),
          company: job_field(job, 'company')
        )
      end
    end

    def job_field(job, field)
      job.xpath(field).text
    end

    def sync_posting(attributes)
      JobPosting.find_or_create_by(link: attributes[:link]).tap do |posting|
        merge_posting_attributes(attributes, posting)
        posting.save
      end
    end

    def merge_posting_attributes(attributes, posting)
      posting.title = attributes[:title]
      posting.description = attributes[:description].squish
      posting.publication_date = attributes[:publication_date]
      posting.icon_url = attributes[:icon_url]
      posting.company = attributes[:company]
    end
  end
end
