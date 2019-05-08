# frozen_string_literal: true

def parse_response_json(response)
  JSON.parse(response.body, symbolize_names: true)
end

def extract_to_json(resource, *keys)
  resource
    .reload
    .attributes
    .symbolize_keys
    .slice(*keys)
    .map { |key, value| [key, (value.is_a?(Integer) ? value : value.to_s)] }
    .to_h
end

RSpec.shared_examples_for 'renders a validation error response' do
  before { request }

  it 'renders an http error' do
    expect(response).to have_http_status(:bad_request)
  end

  it 'renders error structure' do
    expect(parse_response_json(response)).to include(
      status: 'error',
      errors: be_an_instance_of(Hash)
    )
  end
end

RSpec.shared_examples_for 'renders a not found error response' do
  before { request }

  it 'renders a 404 Not Found error' do
    expect(response).to have_http_status :not_found
  end

  it 'renders error structure' do
    expect(parse_response_json(response)).to include(
      status: 'error',
      error: be_an_instance_of(String)
    )
  end
end

RSpec.shared_examples_for 'renders a successful http status code' do
  it 'renders a success http status code' do
    request
    expect(response).to be_successful
  end
end
