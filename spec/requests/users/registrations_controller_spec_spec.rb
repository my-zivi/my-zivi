# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  describe '#edit' do
    let(:perform_request) { get edit_user_registration_path }

    before do
      sign_in(user) if user
      perform_request
    end

    context 'when an organization member is signed in' do
      let(:user) { create(:organization_member).user }

      it 'renders template correct' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template 'users/registrations/edit', 'layouts/organizations/application'
      end
    end

    context 'when a civil servant is signed in' do
      let(:user) { create(:civil_servant, :full).user }

      it 'renders template correct' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template 'users/registrations/edit', 'layouts/civil_servants/application'
      end
    end

    context 'when nobody is signed in' do
      let(:user) { nil }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#update' do
    let(:perform_request) { patch user_registration_path, params: { user: user_params } }
    let(:user_params) { { password: new_password, password_confirmation: new_password, current_password: '12345678' } }
    let(:new_password) { 'MyNewSecureP4SSW0RD/' }

    before do
      sign_in(user) if user
    end

    context 'when an organization member is signed in' do
      let(:user) { create(:organization_member).user }

      it 'updates the user' do
        expect { perform_request }.to(change { user.reload.encrypted_password })
        expect(response).to redirect_to organizations_path
      end
    end

    context 'when a civil servant is signed in' do
      let(:user) { create(:civil_servant, :full).user }

      it 'updates the user' do
        expect { perform_request }.to(change { user.reload.encrypted_password })
        expect(response).to redirect_to civil_servants_path
      end
    end

    context 'when nobody is signed in' do
      let(:user) { nil }

      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end
    end
  end
end
