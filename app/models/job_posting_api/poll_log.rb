# frozen_string_literal: true

module JobPostingApi
  class PollLog < ApplicationRecord
    validates :log, :status, presence: true

    enum status: {
      success: 0,
      error: 1
    }
  end
end
