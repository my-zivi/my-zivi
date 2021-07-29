# frozen_string_literal: true

class OverviewCardComponent < ViewComponent::Base
  TYPES = {
    warning: :warning,
    info: :info,
    success: :success
  }.freeze

  def initialize(title:, text:, type:, links:, badge: nil)
    super
    @type = type
    @title = title
    @text = text
    @badge = badge
    @links = links
  end

  private

  def background_class
    {
      TYPES[:warning] => 'corner-background-warning',
      TYPES[:info] => 'corner-background-info',
      TYPES[:success] => 'corner-background-success'
    }.fetch(@type)
  end

  def text_class
    "text-#{@type}"
  end

  def badge_warning
    "badge-soft-#{@type}"
  end

  def links_html
    @links.map do |text, path|
      link_to(path, class: "font-weight-semi-bold fs--1 text-nowrap #{text_class}") do
        concat text
        concat <<-HTML.html_safe
          <i class="fas fa-angle-right ml-1"></i>
        HTML
      end
    end.join
  end
end
