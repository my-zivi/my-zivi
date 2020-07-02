# frozen_string_literal: true

class OverviewCardComponent < ViewComponent::Base
  TYPES = {
    warning: :warning,
    info: :info,
    success: :success
  }.freeze

  def initialize(title:, text:, type:, links:)
    @type = type
    @title = title
    @text = text
    @links = links
  end

  def background_class
    {
      TYPES[:warning] => 'corner-1',
      TYPES[:info] => 'corner-2',
      TYPES[:success] => 'corner-3'
    }.fetch(@type)
  end

  def text_class
    "text-#{@type}"
  end

  def badge_warning
    "badge-soft-#{@type}"
  end

  def links_html
    links.map do |text, path|
      link_to(path, class: 'font-weight-semi-bold fs--1 text-nowrap') do
        concat text
        concat <<-HTML.html_safe
          <i class="fas fa-angle-right ml-1"></i>
        HTML
      end
    end.join('')
  end
end
