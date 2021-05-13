# frozen_string_literal: true

class BlogEntry < ApplicationRecord
  has_rich_text :content

  validates :author, :content, :title, :description, :slug, presence: true
  validate :slug_format

  scope :published, -> { where(published: true) }

  before_validation do
    self.slug = title.parameterize if title.present? && slug.blank?
  end

  def to_param
    slug&.to_s
  end

  private

  def slug_format
    errors.add(:slug, :invalid) if slug.present? && slug.match?(/\s+/)
  end
end
