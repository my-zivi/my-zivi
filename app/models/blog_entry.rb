# frozen_string_literal: true

class BlogEntry < ApplicationRecord
  has_rich_text :content

  validates :author, :content, :title, presence: true
end
