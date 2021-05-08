# frozen_string_literal: true

class BlogEntriesController < ApplicationController
  before_action -> { I18n.locale = :'de-CH' }

  def index
    @blog_entries = BlogEntry.published
  end

  def show
    @blog_entry = BlogEntry.find_by(slug: params[:slug])
  end
end
