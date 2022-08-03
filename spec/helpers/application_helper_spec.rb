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

    context 'with a fallback given' do
      subject(:tag) { helper.webp_picture_pack_tag('my/image.webp', fallback: :jpg) }

      it 'produces a picture tag' do
        expect(tag).to include '<source srcset="media/images/my/image.jpg" type="image/jpeg">'
      end
    end

    context 'when a class is given' do
      subject(:tag) { helper.webp_picture_pack_tag('my/image.webp', class: 'my-custom-class') }

      it 'produces a picture tag' do
        tag
        expect(helper).to have_received(:image_pack_tag).with('my/image.png', class: 'my-custom-class')
      end
    end
  end

  describe '#app_page_title' do
    subject { helper.app_page_title }

    it { is_expected.to eq I18n.t('layouts.application.title') }

    context 'with page title' do
      before { helper.content_for(:page_title, 'Test') }

      it { is_expected.to eq "Test | #{I18n.t('layouts.application.title')}" }
    end
  end

  describe '#js_translations_export' do
    subject(:translations) { helper.js_translations_export(my_translation: 'cool') }

    it 'exports a json of the given translations' do
      expect(translations).to eq '{"myTranslation":"cool"}'
    end
  end
end
