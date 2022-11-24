# frozen_string_literal: true

class JobPosting < ApplicationRecord
  DEFAULT_ICON_URL = '/myzivi-logo.jpg'
  SLUG_IDENTIFIER_LENGTH = 6

  include JobPostingSearchable
  include Sluggable

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
    last_found_at
  ].freeze

  belongs_to :organization, optional: true
  belongs_to :address, optional: true
  has_many :job_posting_workshops, inverse_of: :job_posting, dependent: :destroy
  has_many :workshops, through: :job_posting_workshops
  has_many :available_service_periods, inverse_of: :job_posting, autosave: true, dependent: :destroy

  alias_attribute :required_workshops, :workshops

  validates(*REQUIRED_FIELDS, presence: true)
  validates :identification_number, :slug, uniqueness: true
  validates :identification_number, numericality: { greater_than: 0, allow_nil: true }
  validates :minimum_service_months, :weekly_work_time, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :organization_name, presence: true, if: -> { organization_id.nil? }

  scope :scraped, -> { where(organization: nil) }
  scope :published, -> { where(published: true) }

  accepts_nested_attributes_for :job_posting_workshops, :available_service_periods, :address, allow_destroy: true

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

  enum canton: I18n.t('activerecord.enums.job_posting.cantons').keys.map(&:to_sym).index_with(&:to_s)

  has_rich_text :description
  has_rich_text :required_skills
  has_rich_text :preferred_skills

  def scraped?
    organization.blank?
  end

  def icon_url
    if organization&.thumb_icon.present?
      return Rails.application.routes.url_helpers.rails_representation_url(
        organization.thumb_icon,
        only_path: true
      )
    end

    DEFAULT_ICON_URL
  end

  def default_slug
    "#{identification_number.to_s.rjust(SLUG_IDENTIFIER_LENGTH, '0')}-#{title.parameterize}"
  end
end
