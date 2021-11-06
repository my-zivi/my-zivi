# frozen_string_literal: true

class BlogEntry < ApplicationRecord
  SUPPORTED_TAGS = %w[article news podcast].freeze

  include Sluggable

  has_rich_text :content

  validates :author, :content, :title, :description, :slug, presence: true
  validates :tags, inclusion: { in: SUPPORTED_TAGS }

  scope :published, -> { where(published: true) }
  scope :including_tags, lambda { |*tags|
    merge(tags.map { |tag| BlogEntry.where('? = ANY(tags)', tag) }.reduce(&:or))
  }

  def default_slug
    title.parameterize
  end
end
