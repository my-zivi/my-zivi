# frozen_string_literal: true

require 'uri'
require 'net/http'

module JobPostingApi
  class ApiError < StandardError
    def initialize(msg = nil, **extra)
      super
      @extra = extra
    end

    def sentry_context
      { extra: @extra }
    end
  end

  class DeactivatedJobPostingsPoller
    def perform
      response = Net::HTTP.get_response(URI("#{ENV['JOB_POSTINGS_API_URL']}/deleted.json"))

      raise ApiError('API returned non-200 status code', response: response) unless response.code.match?(/2\d\d/)

      json_response = JSON.parse(response.body, symbolize_names: true)
      raise ApiError("API returned error status (#{json_response[:status]})") if json_response[:status] != 'ok'

      handle_response(json_response)
    end

    private

    def handle_response(json_response)
      deleted_identification_numbers = json_response[:deleted]
      return if deleted_identification_numbers.empty?

      deleted_identification_numbers.in_groups_of(100, false) do |identification_number_group|
        # rubocop:disable Rails/SkipsModelValidations
        JobPosting.scraped.where(identification_number: identification_number_group).update_all(
          published: false,
          updated_at: Time.zone.now
        )
        # rubocop:enable Rails/SkipsModelValidations
      end

      Rails.logger.info "Deactivated #{deleted_identification_numbers.length} job postings"
    end
  end
end
