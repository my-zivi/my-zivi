# frozen_string_literal: true

module JobPostingApi
  class Parser
    class << self
      STRING_FIELDS = {
        title: 'title',
        description: 'description',
        organization_name: 'organization_name',
        canton: 'canton',
        category: 'category',
        sub_category: 'sub_category',
        language: 'language',
        required_skills: 'required_skills',
        preferred_skills: 'preferred_skills'
      }.freeze

      INTEGER_FIELDS = {
        identification_number: 'identification_number',
        minimum_service_months: 'minimum_service_months'
      }.freeze

      BOOLEAN_FIELDS = {
        priority_program: 'focus_program'
      }.freeze

      ADDRESS_FIELDS = {
        primary_line: 'primary_line',
        secondary_line: 'secondary_line',
        street: 'street',
        supplement: 'supplement',
        city: 'city',
        zip: 'zip',
        latitude: 'lat',
        longitude: 'lng'
      }.freeze

      BRIEF_DESCRIPTION_LENGTH = 120

      def parse_job_posting_attributes(job_posting_xml)
        parse_string_fields(job_posting_xml).merge(
          **parse_integer_fields(job_posting_xml),
          **parse_boolean_fields(job_posting_xml),
          **address_attributes(job_posting_xml),
          **required_workshops_attributes(job_posting_xml),
          **available_service_periods_attributes(job_posting_xml),
          publication_date: Date.parse(job_field(job_posting_xml, 'publication_date')),
          brief_description: ActionController::Base.helpers.strip_tags(job_field(job_posting_xml, 'description'))
                               .squish
                               .truncate(BRIEF_DESCRIPTION_LENGTH)
        )
      end

      private

      def address_attributes(job_posting_xml)
        address = job_posting_xml.xpath('address')
        attributes = ADDRESS_FIELDS.transform_values do |xml_key|
          address.xpath(xml_key).text&.squish.presence
        end

        attributes[:latitude] &&= attributes[:latitude].to_f
        attributes[:longitude] &&= attributes[:longitude].to_f

        { address_attributes: attributes }
      end

      def required_workshops_attributes(job_posting_xml)
        required_workshops = job_posting_xml.xpath('required_courses/required_course')
        workshop_names = required_workshops.map { |xml| xml.text.squish.presence }

        return {} if workshop_names.empty?

        workshop_ids = Workshop.where(name: workshop_names).pluck(:id)

        {
          job_posting_workshops_attributes: workshop_ids.map { |id| { workshop_id: id } }
        }
      end

      def available_service_periods_attributes(job_posting_xml)
        available_periods = job_posting_xml.xpath('free_service_periods/free_service_period')

        return {} if available_periods.empty?

        available_periods = available_periods.map do |available_period|
          {
            beginning: Date.parse(available_period.attr('beginning')),
            ending: Date.parse(available_period.attr('ending'))
          }
        end

        { available_service_periods_attributes: available_periods }
      end

      def parse_integer_fields(job_posting_xml)
        INTEGER_FIELDS.transform_values { |xml_key| job_field(job_posting_xml, xml_key).to_i }
      end

      def parse_boolean_fields(job_posting_xml)
        BOOLEAN_FIELDS.transform_values { |xml_key| job_field(job_posting_xml, xml_key) == 'true' }
      end

      def parse_string_fields(job_posting_xml)
        STRING_FIELDS.transform_values { |xml_key| job_field(job_posting_xml, xml_key) }
      end

      def job_field(job, field)
        job.xpath(field).text&.squish&.presence
      end
    end
  end
end
