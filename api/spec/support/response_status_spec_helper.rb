# frozen_string_literal: true

RSpec.shared_examples_for 'renders a not found error response' do
  before { request }

  it 'renders a 404 Not Found error' do
    expect(response).to have_http_status :not_found
  end

  it 'renders error structure' do
    expect(parse_response_json(response)).to include(error: be_an_instance_of(String))
  end
end

RSpec.shared_examples_for 'renders a successful http status code' do
  it 'renders a success http status code' do
    request
    expect(response).to be_successful
  end
end
