# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class JobPollerService
  class << self
    URL = 'https://www.myzivi.ch/feeds/standard.xml'

    def poll
      URI.parse(URL).open do |page|
        feed = Nokogiri::XML(page, &:noblanks)
        jobs = feed.xpath('//job')
        jobs.map do |job|
          sync_posting(
            title: job_field(job, 'title'),
            publication_date: Date.parse(job_field(job, 'date')),
            description: job_field(job, 'description'),
            link: job_field(job, 'applyurl'),
            icon_url: job_field(job, 'companylogo')
          )
        end
      end
    end

    private

    def job_field(job, field)
      job.xpath(field).text
    end

    def sync_posting(link:, title:, description:, publication_date:, icon_url:)
      JobPosting.find_or_create_by(link: link) do |posting|
        posting.title = title
        posting.description = description.squish
        posting.publication_date = publication_date
        posting.icon_url = icon_url
      end
    end
  end
end
