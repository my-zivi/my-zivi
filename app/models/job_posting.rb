# frozen_string_literal: true

class JobPosting < ApplicationRecord
  validates :link, :title, :publication_date, :description, presence: true
  validates :link, uniqueness: true
end
