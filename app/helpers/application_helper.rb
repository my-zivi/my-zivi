# frozen_string_literal: true

module ApplicationHelper
  def webp_picture_pack_tag(path, **kwargs)
    base_path = "#{File.dirname(path)}/#{File.basename(path, File.extname(path))}"
    extension = kwargs.delete(:fallback) || :png
    mime = Mime::Type.lookup_by_extension(extension).to_s

    generate_picture_tag(base_path, extension, mime, **kwargs)
  end

  def navbar_link(name, path)
    tag.li(class: "nav-item #{current_page?(path) ? 'active font-weight-bold' : ''}".squish) do
      link_to(name, path, class: 'nav-link')
    end
  end

  def app_page_title
    page_title(app_name: t('layouts.application.title'), separator: ' | ', reverse: true)
  end

  def js_translations_export(translations)
    translations.deep_transform_keys { |key| key.to_s.camelize(:lower) }.to_json
  end

  private

  def current_url
    request.base_url + request.fullpath
  end

  def generate_picture_tag(base_path, extension, mime, **kwargs)
    fallback_image_name = "#{base_path}.#{extension}"

    tag.picture do
      concat tag.source(srcset: asset_pack_path("media/images/#{base_path}.webp"), type: 'image/webp')
      concat tag.source(srcset: asset_pack_path("media/images/#{fallback_image_name}"), type: mime)
      concat vite_image_tag(fallback_image_name, **kwargs)
    end
  end
end
