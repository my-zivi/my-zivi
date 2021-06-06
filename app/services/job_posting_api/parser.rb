# frozen_string_literal: true

module JobPostingApi
  class Parser
    class << self
      def parse_job_posting_attributes(job_posting_xml)
        {
          identification_number: job_field(job_posting_xml, 'identification_number').to_i,
          title: job_field(job_posting_xml, 'title'),
          publication_date: Date.parse(job_field(job_posting_xml, 'pubDate')),
          description: job_field(job_posting_xml, 'description'),
          organization_name: job_field(job_posting_xml, 'organization_name'),
          required_skills: job_field(job_posting_xml, 'required_skills'),
          preferred_skills: job_field(job_posting_xml, 'preferred_skills'),
          canton: job_field(job_posting_xml, 'canton'),
          category: job_field(job_posting_xml, 'category'),
          sub_category: job_field(job_posting_xml, 'sub_category'),
          language: job_field(job_posting_xml, 'language'),
          minimum_service_months: job_field(job_posting_xml, 'minimum_service_months').to_i
        }
      end

      private

      def job_field(job, field)
        job.xpath(field).text.squish.presence
      end
    end
  end
end
