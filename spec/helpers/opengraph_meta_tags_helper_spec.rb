# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpengraphMetaTagsHelper do
  describe '#opengraph_tags' do
    subject { helper.opengraph_tags }

    it { is_expected.to include('meta').exactly(4) }
  end

  describe '#description_tag' do
    subject { helper.description_tag }

    it { is_expected.to eq "<meta name=\"description\" content=\"#{I18n.t('layouts.application.meta.description')}\">" }

    context 'with custom description' do
      before do
        helper.content_for(:page_description, 'custom')
      end

      it { is_expected.to eq '<meta name="description" content="custom">' }
    end
  end

  describe '#opengraph_type' do
    subject { helper.opengraph_type }

    it { is_expected.to eq '<meta property="og:type" content="website">' }

    context 'with custom type' do
      before do
        helper.content_for(:og_type, 'custom')
      end

      it { is_expected.to eq '<meta property="og:type" content="custom">' }
    end
  end

  describe '#opengraph_title_tag' do
    subject { helper.opengraph_title_tag }

    it { is_expected.to eq "<meta property=\"og:title\" content=\"#{t('layouts.application.meta.og_title')}\">" }

    context 'with custom type' do
      before do
        helper.content_for(:page_title, 'custom')
      end

      it { is_expected.to eq '<meta property="og:title" content="custom">' }
    end
  end

  describe '#opengraph_image_meta_tag' do
    subject { helper.opengraph_image_meta_tag }

    let(:request) { Rack::Request.new(Rack::MockRequest.env_for('https://www.myzivi.ch/my/url')) }
    let(:expected_content) do
      'https://mugshotbot.com/m?color=009fe3&hide_watermark=true&mode=light' \
        '&pattern=topography&url=https%3A%2F%2Fwww.myzivi.ch%2Fmy%2Furl'
    end

    before { allow(helper).to receive(:request).and_return request }

    it { is_expected.to eq "<meta property=\"og:image\" content=\"#{expected_content}\">" }
  end
end
