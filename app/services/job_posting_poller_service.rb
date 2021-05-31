# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class JobPostingPollerService
  class << self
    PATH = '/feeds/standard.xml'
    DEFAULT_ATTRIBUTES = {
      organization_name: 'MyZivi',
      canton: 'Zürich',
      category: JobPosting.categories[:nature_conservancy],
      sub_category: JobPosting.sub_categories[:landscape_conservation],
      language: JobPosting.languages[:german],
      minimum_service_length: '1 Monat(e)',
      contact_information: <<~TEXT.squish
        Dieser Betrieb ist noch nicht bei MyZivi registriert.
        Bitte bewerbe Dich im EZIVI.
      TEXT
    }.freeze

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
      identification_number = JobPosting.order(:identification_number).last&.identification_number || 0
      JobPosting.find_or_create_by(link: attributes[:link]).tap do |posting|
        identification_number += 1
        posting.assign_attributes(
          format_posting_attributes(identification_number: identification_number, **attributes)
        )
        posting.save
      end
    end

    def format_posting_attributes(attributes)
      attributes.slice(:title, :publication_date, :icon_url, :company, :identification_number).merge(
        **DEFAULT_ATTRIBUTES,
        description: attributes[:description].squish
      )
    end
  end
end
