# frozen_string_literal: true

class JobPosting < ApplicationRecord
  REQUIRED_FIELDS = %i[
    title
    publication_date
    description
    canton
    identification_number
    category
    language
    minimum_service_months
    contact_information
  ].freeze

  belongs_to :organization, optional: true
  belongs_to :address, optional: true
  has_many :job_posting_workshops, inverse_of: :job_posting, dependent: :destroy
  has_many :workshops, through: :job_posting_workshops
  has_many :available_service_periods, inverse_of: :job_posting, autosave: true, dependent: :destroy

  alias_attribute :required_workshops, :workshops

  validates(*REQUIRED_FIELDS, presence: true)
  validates :identification_number, uniqueness: true
  validates :identification_number, numericality: { greater_than: 0, allow_nil: true }
  validates :minimum_service_months, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  accepts_nested_attributes_for :job_posting_workshops, :available_service_periods, allow_destroy: true

  enum language: {
    german: 'de-CH',
    french: 'fr-CH',
    italian: 'it-CH'
  }

  enum category: {
    nature_conservancy: 'nature_conservancy',
    healthcare: 'healthcare',
    social_welfare: 'social_welfare',
    preservation_of_cultural_assets: 'preservation_of_cultural_assets',
    agriculture: 'agriculture',
    development_cooperation: 'development_cooperation',
    disaster_relief: 'disaster_relief',
    education: 'education'
  }

  enum sub_category: {
    assistance_service: 'assistance_service',
    support_and_accompaniment: 'supportand_accompaniment',
    handicraft_work: 'handicraft_work',
    housekeeping: 'housekeeping',
    housekeeping_and_hotel: 'housekeepingand_hotel',
    kitchen: 'kitchen',
    landscaping_and_gardening: 'landscaping_and_gardening',
    landscape_conservation: 'landscape_conservation',
    collaboration_in_the_company: 'collaboration_in_the_company',
    organisation_and_participation_in_camps: 'organisation_and_participation_in_camps',
    pedagogical_work: 'pedagogical_work',
    passenger_transport: 'passenger_transport',
    maintenance: 'maintenance',
    processing: 'processing',
    other: 'other',
    social_care_and_counselling: 'social_care_and_counselling',
    scientific_work: 'scientific_work',
    alp_care: 'alp_care',
    forestry_work: 'forestry_work'
  }
end
