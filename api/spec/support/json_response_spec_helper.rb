# frozen_string_literal: true

def parse_response_json(response)
  JSON.parse(response.body, symbolize_names: true)
end

def is_a_boolean?(value)
  value.in? [true, false]
end

def convert_to_json_value(value)
  return value if value.is_a?(Integer) || is_a_boolean?(value) || value.nil?
  return value.symbolize_keys if value.is_a?(Hash)

  value.to_s
end

def extract_to_json(resource, *keys)
  extracted = resource.reload.attributes.symbolize_keys
  extracted
    .slice(*(keys.empty? ? extracted.keys : keys))
    .transform_values(&method(:convert_to_json_value))
end

RSpec.shared_examples_for 'renders a validation error response' do
  let(:json_response) { parse_response_json(response) }

  before { request }

  it 'renders an http error' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'renders error structure' do
    expect(json_response).to include(
      errors: be_an_instance_of(Hash).and(have_at_least(1).items),
      human_readable_descriptions: be_an_instance_of(Array).and(have_at_least(1).items)
    )
  end
end
