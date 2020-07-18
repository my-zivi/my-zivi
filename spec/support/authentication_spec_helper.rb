# frozen_string_literal: true

RSpec.shared_examples_for 'unauthenticated request' do
  it 'redirects back to login path' do
    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated')
  end
end
