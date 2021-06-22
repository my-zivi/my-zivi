# frozen_string_literal: true

class JobPostingPollJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 2

  def perform(*)
    JobPosting.without_auto_index do
      JobPostingApi::Poller.new.perform
    end

    JobPosting.reindex!
  end
end
