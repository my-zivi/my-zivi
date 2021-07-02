# frozen_string_literal: true

class JobPostingWorkshop < ApplicationRecord
  belongs_to :workshop
  belongs_to :job_posting
end
