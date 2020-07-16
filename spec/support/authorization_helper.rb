# frozen_string_literal: true

RSpec.shared_examples_for 'unauthorized request' do |resource = nil|
  it 'renders unauthorized response' do
    expect(response).to redirect_to(resource || organizations_path)
    expect(flash[:error]).to eq I18n.t('not_allowed')
  end
end
