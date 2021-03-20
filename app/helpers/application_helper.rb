# frozen_string_literal: true

module ApplicationHelper
  def webp_picture_pack_tag(path, **kwargs)
    basepath = "#{File.dirname(path)}/#{File.basename(path, File.extname(path))}"

    tag.picture do
      concat tag.source(srcset: asset_pack_path("media/images/#{basepath}.webp"), type: 'image/webp')
      concat tag.source(srcset: asset_pack_path("media/images/#{basepath}.png"), type: 'image/png')
      concat image_pack_tag("#{basepath}.png", **kwargs)
    end
  end

  def navbar_link(name, path)
    tag.li(class: "nav-item #{current_page?(path) ? 'active' : ''}".squish) do
      link_to(name, path, class: 'nav-link')
    end
  end
end
