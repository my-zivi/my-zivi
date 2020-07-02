# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OverviewCardComponent, type: :component do
  subject(:component) do
    described_class.new(title: title, text: text, type: type, links: links, badge: badge)
  end

  let(:rendered) { render_inline(component) }
  let(:title) { 'My title' }
  let(:text) { 'My text' }
  let(:type) { described_class::TYPES[:info] }
  let(:links) { {} }
  let(:badge) { nil }
  let(:badge_element) { rendered.css('[data-badge]') }

  it 'renders title and text and no badge' do
    expect(rendered.css('h6').text).to eq title
    expect(rendered.css('[data-text]').text).to eq text
    expect(badge_element).to be_empty
  end

  context 'when there is a badge' do
    subject { badge_element }

    let(:badge) { 'My badge content' }

    it { is_expected.to be_present }
  end

  describe 'card style' do
    subject { rendered.css('[data-card]').to_html }

    context 'when card type is info' do
      it { is_expected.to include 'corner-background-info' }
    end

    context 'when card type is warning' do
      let(:type) { described_class::TYPES[:warning] }

      it { is_expected.to include 'corner-background-warning' }
    end

    context 'when card type is success' do
      let(:type) { described_class::TYPES[:success] }

      it { is_expected.to include 'corner-background-success' }
    end
  end

  describe 'links' do
    let(:anchors) { rendered.css('a') }

    context 'when there are no links' do
      it 'does not have any anchors' do
        expect(anchors).to be_empty
      end
    end

    context 'when there is one line' do
      subject(:link) { anchors.first }

      let(:text) { 'My custom link' }
      let(:path) { '/my/path' }

      let(:links) { { text => path } }

      it 'has correct attributes' do
        expect(link.attr('href')).to eq path
        expect(link.text.squish).to eq text
      end
    end

    context 'when there are multiple links' do
      subject { anchors.length }

      let(:links) { { 'Link 1' => '/lord/voldemort', 'Link 2' => '9000/du/bisch/grusig' } }

      it { is_expected.to eq 2 }
    end
  end
end
