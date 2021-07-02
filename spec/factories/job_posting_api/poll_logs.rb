# frozen_string_literal: true

FactoryBot.define do
  factory :job_posting_api_poll_log, class: 'JobPostingApi::PollLog' do
    log { '{}' }
    status { 'success' }
  end
end
