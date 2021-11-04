# frozen_string_literal: true

RSpec.shared_examples_for 'validates presence of breadcrumbs' do
  let(:html) { Nokogiri::XML(response.body, &:noblanks) }

  it 'validates that all breadcrumbs are present' do
    last_breadcrumb_index = expected_breadcrumbs.length
    last_breadcrumb = expected_breadcrumbs.pop

    expected_breadcrumbs.each_with_index do |breadcrumb, index|
      index += 1
      expect(html.at_css(".breadcrumb .breadcrumb-item:nth-child(#{index}) a").text).to eq breadcrumb
    end

    expect(html.at_css(".breadcrumb .breadcrumb-item:nth-child(#{last_breadcrumb_index})").text).to eq last_breadcrumb
  end
end
