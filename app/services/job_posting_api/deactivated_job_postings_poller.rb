# frozen_string_literal: true

module JobPostingApi
  class DeactivatedJobPostingsPoller
    DEACTIVATION_PERIOD = ENV.fetch('JOB_POSTING_DEACTIVATION_PERIOD', 4).months

    def perform
      unpublish_job_postings
      publish_job_postings
    end

    private

    # rubocop:disable Rails/SkipsModelValidations
    def unpublish_job_postings
      JobPosting.scraped.where('last_found_at < ?', Time.zone.today - DEACTIVATION_PERIOD).update_all(
        updated_at: Time.zone.now,
        published: false
      )
    end

    def publish_job_postings
      JobPosting.scraped.where('last_found_at >= ?', Time.zone.today - DEACTIVATION_PERIOD).update_all(
        updated_at: Time.zone.now,
        published: true
      )
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
