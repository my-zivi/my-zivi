# frozen_string_literal: true

require 'uri'
require 'net/http'

module JobPostingApi
  class ApiError < StandardError
    def initialize(msg = nil, **extra)
      super(msg)
      @extra = extra
    end

    def sentry_context
      { extra: @extra }
    end
  end

  class DeactivatedJobPostingsPoller
    def perform
      response = Net::HTTP.get_response(URI(ENV['DEACTIVATED_JOB_POSTINGS_API_URL']))

      raise ApiError.new('API returned non-200 status code', response: response) unless response.code.match?(/2\d\d/)

      json_response = JSON.parse(response.body, symbolize_names: true)
      raise ApiError, "API returned error status (#{json_response[:status]})" if json_response[:status] != 'ok'

      handle_response(json_response)
    end

    private

    def handle_response(json_response)
      remote_unpublished_job_posting = json_response[:deleted]
      return if remote_unpublished_job_posting.empty?

      local_unpublished_job_postings = JobPosting.scraped.where(published: false).pluck(:identification_number)
      unpublish_job_postings(local_unpublished_job_postings, remote_unpublished_job_posting)
      publish_job_postings(local_unpublished_job_postings, remote_unpublished_job_posting)
    end

    def unpublish_job_postings(local_unpublished_job_postings, remote_unpublished_job_posting)
      needs_unpublishing = remote_unpublished_job_posting.difference(local_unpublished_job_postings)
      update_job_postings_in_group(needs_unpublishing, published: false)

      Rails.logger.info "Deactivated #{needs_unpublishing.length} job postings"
    end

    def publish_job_postings(local_unpublished_job_postings, remote_unpublished_job_posting)
      needs_publishing = local_unpublished_job_postings.difference(remote_unpublished_job_posting)
      update_job_postings_in_group(needs_publishing, published: true)

      Rails.logger.info "Reactivated #{needs_publishing.length} job postings"
    end

    def update_job_postings_in_group(identification_numbers, job_posting_parameters)
      identification_numbers.in_groups_of(100, false) do |identification_number_group|
        # rubocop:disable Rails/SkipsModelValidations
        JobPosting.scraped.where(identification_number: identification_number_group).update_all(
          updated_at: Time.zone.now,
          **job_posting_parameters
        )
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
