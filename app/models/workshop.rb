# frozen_string_literal: true

class Workshop < ApplicationRecord
  has_many :service_specifications_workshops, dependent: :restrict_with_exception
  has_many :service_specifications, through: :service_specifications_workshops

  has_many :civil_servants_workshops, dependent: :restrict_with_exception
  has_many :civil_servants, through: :civil_servants_workshops

  has_many :job_posting_workshops, dependent: :destroy
  has_many :job_postings, through: :job_posting_workshops

  validates :name, presence: true
end
