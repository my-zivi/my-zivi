# frozen_string_literal: true

module OpengraphMetaTagsHelper
  MUGSHOTBOT_CONFIG = {
    mode: 'light',
    color: '009fe3',
    pattern: 'topography',
    hide_watermark: true
  }.freeze

  def opengraph_tags
    safe_join([opengraph_title_tag, description_tag, opengraph_image_meta_tag, opengraph_type])
  end

  def description_tag
    content = content_for(:page_description) || t('layouts.application.meta.description')
    tag.meta(name: 'description', content: content)
  end

  def opengraph_type
    content = content_for(:og_type) || 'website'
    tag.meta(property: 'og:type', content: content)
  end

  def opengraph_title_tag
    content = content_for(:page_title) || t('layouts.application.meta.og_title')
    tag.meta(property: 'og:title', content: content)
  end

  def opengraph_image_meta_tag
    config = { **MUGSHOTBOT_CONFIG, url: current_url }

    # rubocop:disable Rails/OutputSafety
    tag.meta(property: 'og:image', content: "https://mugshotbot.com/m?#{config.to_query}".html_safe)
    # rubocop:enable Rails/OutputSafety
  end
end
