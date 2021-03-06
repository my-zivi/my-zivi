# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#webp_picture_pack_tag' do
    subject(:tag) { helper.webp_picture_pack_tag('my/image.webp') }

    before do
      allow(helper).to receive(:asset_pack_path) do |path|
        path
      end

      allow(helper).to receive(:image_pack_tag) do |path|
        "<img src=\"#{path}\" />".html_safe
      end
    end

    it 'produces a picture tag' do
      expect(tag).to eq <<~HTML.squish.gsub(/> </, '><')
        <picture>
          <source srcset="media/images/my/image.webp" type="image/webp">
          <source srcset="media/images/my/image.png" type="image/png">
          <img src="my/image.png" />
        </picture>
      HTML
    end

    context 'when a class is given' do
      subject(:tag) { helper.webp_picture_pack_tag('my/image.webp', class: 'my-custom-class') }

      it 'produces a picture tag' do
        expect(tag).to eq <<~HTML.squish.gsub(/> </, '><')
          <picture class="my-custom-class">
            <source srcset="media/images/my/image.webp" type="image/webp">
            <source srcset="media/images/my/image.png" type="image/png">
            <img src="my/image.png" />
          </picture>
        HTML
      end
    end
  end
end
