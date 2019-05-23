# frozen_string_literal: true

def parse_response_json(response)
  JSON.parse(response.body, symbolize_names: true)
end

def is_a_boolean?(value)
  value.in? [true, false]
end

def convert_to_json_value(value)
  return value if value.is_a?(Integer) || is_a_boolean?(value) || value.is_a?(Hash)

  value.to_s
end

def extract_to_json(resource, *keys)
  resource
    .reload
    .attributes
    .symbolize_keys
    .slice(*keys)
    .map { |key, value| [key, convert_to_json_value(value)] }
    .to_h
end

RSpec.shared_examples_for 'renders a validation error response' do
  before { request }

  it 'renders an http error' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'renders error structure' do
    expect(parse_response_json(response)).to include(errors: be_an_instance_of(Hash))
  end
end
