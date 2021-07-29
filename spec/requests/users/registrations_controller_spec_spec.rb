# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  describe '#edit' do
    let(:perform_request) { get edit_user_registration_path }

    context 'when an organization member is signed in' do
      let(:user) { create(:organization_member).user }

      before do
        sign_in user
        perform_request
      end

      it 'renders template correct' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template 'users/registrations/edit', 'layouts/organizations/application'
      end
    end

    it_behaves_like 'admin subscription route only', skip_civil_servant_check: true
  end

  describe '#update' do
    let(:perform_request) { patch user_registration_path, params: { user: user_params } }
    let(:user_params) { { password: new_password, password_confirmation: new_password, current_password: '12345678' } }
    let(:new_password) { 'MyNewSecureP4SSW0RD/' }

    context 'when an organization member is signed in' do
      let(:user) { create(:organization_member).user }

      before { sign_in user }

      it 'updates the user' do
        expect { perform_request }.to(change { user.reload.encrypted_password })
        expect(response).to redirect_to organizations_path
      end
    end

    it_behaves_like 'admin subscription route only', skip_civil_servant_check: true
  end
end
