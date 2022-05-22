# frozen_string_literal: true

class BlogEntriesController < ApplicationController
  include Pagy::Backend

  ITEMS = 20

  authorize_resource

  around_action do |_controller, action|
    I18n.with_locale(:'de-CH', &action)
  end

  def index
    @pagy, @blog_entries = pagy(
      BlogEntry.published.including_tags(*filter_params[:tags]).order(created_at: :desc),
      items: ITEMS
    )
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
    filter = params.permit(filter: { tags: [] })[:filter] || {}
    filter[:tags] ||= BlogEntry::SUPPORTED_TAGS
    @filter_params = filter
  end
end
