# frozen_string_literal: true

class BlogEntry < ApplicationRecord
  include Sluggable

  has_rich_text :content

  validates :author, :content, :title, :description, :slug, presence: true

  scope :published, -> { where(published: true) }

  def default_slug
    title.parameterize
  end
end
