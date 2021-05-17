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

  describe '#navbar_link' do
    subject(:link) { helper.navbar_link('MyLink', '/my-path') }

    it 'creates a sidebar link' do
      expect(link).to eq '<li class="nav-item"><a class="nav-link" href="/my-path">MyLink</a></li>'
    end

    context 'when it\'s the current page' do
      before do
        allow(helper).to receive(:current_page?).and_return true
      end

      it 'creates an active sidebar link' do
        expect(link).to include 'nav-item active font-weight-bold'
      end
    end
  end

  describe '#app_page_title' do
    subject { helper.app_page_title }

    it { is_expected.to eq I18n.t('layouts.application.title') }

    context 'with page title' do
      before { helper.content_for(:page_title, 'Test') }

      it { is_expected.to eq "#{I18n.t('layouts.application.title')} | Test" }
    end
  end
end
