# frozen_string_literal: true

def escape_to_pdf_string(value)
  escaped_value = value.to_s.dup
  [%w[( \\(], %w[) \\)]].each { |replacement| escaped_value.gsub!(replacement[0], replacement[1]) }
  escaped_value
end

RSpec.shared_examples_for 'pdf renders correct texts' do
  it 'xobject_values contains all expected_strings', :aggregate_failures do
    expected_strings.each do |value|
      escaped_value = escape_to_pdf_string(value)
      expect(xobjects_values).to include escaped_value
    end
  end
end
