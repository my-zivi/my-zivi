# frozen_string_literal: true

class JobPostingPollJob < ApplicationJob
  queue_as :default

  def perform(*)
    JobPostingPollerService.poll
  end
end
