# frozen_string_literal: true

class BlogEntriesController < ApplicationController
  authorize_resource

  before_action -> { I18n.locale = :'de-CH' }

  def index
    @blog_entries = BlogEntry.published.order(created_at: :desc)
  end

  def show
    @blog_entry = BlogEntry.find_by(slug: params[:slug])
    raise ActiveRecord::RecordNotFound unless can?(:read, @blog_entry)
  end
end
