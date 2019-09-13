# frozen_string_literal: true

RSpec.shared_examples_for 'format protected resource' do
  subject { response }

  before { request }

  it { is_expected.to have_http_status(:not_acceptable) }

  it 'renders an error' do
    expect(parse_response_json(response)).to include(
      error: I18n.t('errors.format_error')
    )
  end
end
