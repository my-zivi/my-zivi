# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    validate :slug_format

    before_validation do
      self.slug = default_slug if title.present? && slug.blank?
    end
  end

  def to_param
    slug&.to_s
  end

  private

  def slug_format
    errors.add(:slug, :invalid) if slug.present? && slug.match?(/\s+/)
  end
end
