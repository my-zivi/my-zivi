# frozen_string_literal: true

RSpec.shared_examples_for 'unauthorized request' do
  it 'renders unauthorized response' do
    expect(response.body).to eq I18n.t('not_allowed')
    expect(response).to have_http_status(401)
  end
end
