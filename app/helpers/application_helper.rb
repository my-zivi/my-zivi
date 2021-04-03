# frozen_string_literal: true

module ApplicationHelper
  def webp_picture_pack_tag(path, **kwargs)
    basepath = "#{File.dirname(path)}/#{File.basename(path, File.extname(path))}"
    alternative_extension = kwargs.delete(:fallback) || :png

    tag.picture do
      concat tag.source(srcset: asset_pack_path("media/images/#{basepath}.webp"), type: 'image/webp')
      concat tag.source(srcset: asset_pack_path("media/images/#{basepath}.#{alternative_extension}"), type: 'image/png')
      concat image_pack_tag("#{basepath}.#{alternative_extension}", **kwargs)
    end
  end

  def navbar_link(name, path)
    tag.li(class: "nav-item #{current_page?(path) ? 'active' : ''}".squish) do
      link_to(name, path, class: 'nav-link')
    end
  end
end
