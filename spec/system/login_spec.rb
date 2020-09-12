# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login/Logout', type: :system do
  context 'when user is an organization administrator' do
    let(:organization_administrator) { create(:organization_member) }

    it 'can sign in' do
      visit new_user_session_path
      submit_sign_in_form(organization_administrator.user)
      expect(page).to have_current_path organizations_path
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
    end
  end

  context 'when user is a civil servant' do
    let(:civil_servant) { create(:civil_servant, :full) }

    it 'can sign in' do
      visit new_user_session_path
      submit_sign_in_form(civil_servant.user)
      expect(page).to have_current_path civil_servants_path
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
    end
  end
end
