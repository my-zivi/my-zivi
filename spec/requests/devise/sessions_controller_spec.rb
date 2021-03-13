# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :request do
  describe '/users/sign_in' do
    subject { response }

    before { post(user_session_path, params: { user: { email: user.email, password: user.password } }) }

    context 'when a civil servants signs in' do
      let(:civil_servant) { create :civil_servant, :full }
      let(:user) { civil_servant.user }

      it { is_expected.to redirect_to(civil_servants_path) }

      context 'when civil servant has not fully completed registration yet' do
        let(:civil_servant) { create :civil_servant, :with_user, :personal_step_completed }

        it { is_expected.to redirect_to(civil_servants_register_path) }
      end
    end

    context 'when a organization member signs in' do
      let(:organization_member) { create :organization_member }
      let(:user) { organization_member.user }

      it 'signs in without a success message' do
        expect(response).to redirect_to(organizations_path)
        follow_redirect!
        expect(response.body).not_to include(I18n.t('devise.sessions.signed_in'))
      end
    end
  end

  context 'when signing out' do
    let(:perform_request) { delete destroy_user_session_path }
    let(:organization_member) { create :organization_member }

    before do
      sign_in organization_member.user
      perform_request
    end

    it 'signs out and shows no success message', :without_bullet do
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).not_to include(I18n.t('devise.sessions.signed_out'))
    end
  end
end
