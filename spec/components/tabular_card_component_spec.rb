# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TabularCardComponent, type: :component do
  let(:rendered) { render_inline(component) }
  let(:component) { described_class.new(title: title, table_content: table_content) }
  let(:title) { 'My title' }
  let(:table_content) { { Test: 'Hans' } }

  it 'renders id and title' do
    expect(rendered.css('h4').text).to eq title
    expect(rendered.css('.mb-lg-1.col-12.col-xxl-5.font-weight-bold').text).to eq table_content.keys.first.to_s
    expect(rendered.css('.mb-1.col-12.col-xxl-7').text).to eq table_content.values.first.to_s
  end

  context 'with the body content_area' do
    let(:rendered) do
      render_inline(component) do |component|
        component.with(:actions, action_content)
      end
    end
    let(:component) { described_class.new(title: title, table_content: table_content) }
    let(:action_content) { 'a beautiful action' }

    it 'renders the action' do
      expect(rendered.css('h4 + div').text).to eq action_content
    end
  end
end
