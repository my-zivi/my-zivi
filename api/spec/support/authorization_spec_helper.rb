# frozen_string_literal: true

RSpec.shared_examples_for 'protected resource' do
  subject { response }

  before { request }

  it { is_expected.to have_http_status(:unauthorized) }

  it 'renders an error' do
    expect(parse_response_json(response)).to include(
      error: I18n.t('devise.failure.unauthenticated')
    )
  end
end
