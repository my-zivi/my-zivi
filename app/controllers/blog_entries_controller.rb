# frozen_string_literal: true

class BlogEntriesController < ApplicationController
  authorize_resource

  before_action -> { I18n.locale = :'de-CH' }

  def index
    @blog_entries = BlogEntry.published.where(filter_params).order(created_at: :desc)
  end

  def show
    @blog_entry = BlogEntry.find_by(slug: slug_params)
    raise ActiveRecord::RecordNotFound unless can?(:read, @blog_entry)
  end

  private

  def slug_params
    params.require(:slug)
  end

  # :reek:DuplicateMethodCall
  def filter_params
    return @filter_params if @filter_params

    filter = params.permit(filter: %i[tags])[:filter] || {}
    filter[:tags] ||= BlogEntry::SUPPORTED_TAGS.first
    filter[:tags] &&= [filter[:tags]]
    @filter_params = filter
  end
end
