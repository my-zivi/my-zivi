# frozen_string_literal: true

module ApplicationHelper
  def webp_picture_pack_tag(path, **kwargs)
    basepath = "#{File.dirname(path)}/#{File.basename(path, File.extname(path))}"

    tag.picture(class: kwargs.delete(:class)) do
      concat tag.source(srcset: asset_pack_path("media/images/#{basepath}.webp"), type: 'image/webp')
      concat tag.source(srcset: asset_pack_path("media/images/#{basepath}.png"), type: 'image/png')
      concat image_pack_tag("#{basepath}.png", **kwargs)
    end
  end
end
