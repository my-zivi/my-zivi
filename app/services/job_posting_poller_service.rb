# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class JobPostingPollerService
  class << self
    URL = 'https://www.myzivi.ch/feeds/standard.xml'

    def poll
      URI.parse(URL).open do |page|
        feed = Nokogiri::XML(page, &:noblanks)
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
    end

    private

    def job_field(job, field)
      job.xpath(field).text
    end

    def sync_posting(link:, title:, description:, publication_date:, icon_url:, company:)
      JobPosting.find_or_create_by(link: link) do |posting|
        posting.title = title
        posting.description = description.squish
        posting.publication_date = publication_date
        posting.icon_url = icon_url
        posting.company = company
      end
    end
  end
end
