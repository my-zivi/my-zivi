# frozen_string_literal: true

class BlogEntry < ApplicationRecord
  has_rich_text :content

  validates :author, :content, :title, :description, :published, presence: true

  scope :published, -> { where(published: true) }

  def to_param
    slug&.to_s
  end
end
