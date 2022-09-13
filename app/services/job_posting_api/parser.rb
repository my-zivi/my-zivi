# frozen_string_literal: true

module JobPostingApi
  class Parser
    class << self
      SIMPLE_FIELDS = %i[title description organization_name canton category sub_category
                         language required_skills preferred_skills identification_number
                         minimum_service_months priority_program publication_date last_found_at].freeze

      ADDRESS_FIELDS = %i[primary_line secondary_line street supplement city zip latitude longitude].freeze

      BRIEF_DESCRIPTION_LENGTH = 120

      def parse_job_posting_attributes(job_posting_hash)
        job_posting_hash.slice(*SIMPLE_FIELDS)
                        .merge(
                          **address_attributes(job_posting_hash),
                          **required_workshops_attributes(job_posting_hash),
                          **available_service_periods_attributes(job_posting_hash),
                          brief_description: ActionController::Base.helpers
                                                                   .strip_tags(job_posting_hash.fetch(:description))
                                                                   .squish
                                                                   .truncate(BRIEF_DESCRIPTION_LENGTH)
                        )
      end

      private

      def address_attributes(job_posting_hash)
        address = job_posting_hash.fetch(:address, {})

        return {} if address.empty?

        { address_attributes: address.slice(*ADDRESS_FIELDS) }
      end

      def required_workshops_attributes(job_posting_hash)
        workshop_names = job_posting_hash.fetch(:required_courses, [])

        return {} if workshop_names.empty?

        workshop_ids = Workshop.where(name: workshop_names).pluck(:id)

        {
          job_posting_workshops_attributes: workshop_ids.map { |id| { workshop_id: id } }
        }
      end

      def available_service_periods_attributes(job_posting_hash)
        available_periods = job_posting_hash.fetch(:free_service_periods, [])

        return {} if available_periods.empty?

        available_periods = available_periods.map do |available_period|
          {
            beginning: Date.parse(available_period.fetch(:beginning)),
            ending: Date.parse(available_period.fetch(:ending))
          }
        end

        { available_service_periods_attributes: available_periods }
      end
    end
  end
end
