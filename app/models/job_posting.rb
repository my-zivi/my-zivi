# frozen_string_literal: true

class JobPosting < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  include JobPostingSearchable

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
    brief_description
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
  validates :organization_name, presence: true, if: -> { organization_id.nil? }

  accepts_nested_attributes_for :job_posting_workshops, :available_service_periods, allow_destroy: true

  enum language: {
    german: 'de-CH',
    french: 'fr-CH',
    italian: 'it-CH'
  }

  enum relevancy: {
    normal: 1,
    urgent: 2,
    featured: 3
  }

  enum category: %i[
    nature_conservancy healthcare social_welfare disaster_relief education
    preservation_of_cultural_assets agriculture development_cooperation
  ].index_with(&:to_s)

  enum sub_category: %i[
    assistance_service support_and_accompaniment handicraft_work housekeeping
    housekeeping_and_hotel kitchen landscaping_and_gardening collaboration_in_the_company
    organisation_and_participation_in_camps pedagogical_work passenger_transport care
    other social_care_and_counselling scientific_work alp_care
    forestry_work processing
  ].index_with(&:to_s)

  def scraped?
    organization.blank?
  end
end
