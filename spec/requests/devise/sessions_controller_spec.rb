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

      it { is_expected.to redirect_to(organizations_path) }
    end
  end
end
