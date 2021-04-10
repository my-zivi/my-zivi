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

  private

  def generate_picture_tag(base_path, extension, mime, **kwargs)
    fallback_image_name = "#{base_path}.#{extension}"

    tag.picture do
      concat tag.source(srcset: asset_pack_path("media/images/#{base_path}.webp"), type: 'image/webp')
      concat tag.source(srcset: asset_pack_path("media/images/#{fallback_image_name}"), type: mime)
      concat image_pack_tag(fallback_image_name, **kwargs)
    end
  end
end
