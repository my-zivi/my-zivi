# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::ResetPasswordInstructionsHelper, type: :helper do
  describe '#reset_link' do
    subject(:reset_link) { helper.reset_link user, token }

    let(:token) { '1234' }
    let(:user) { build :user }

    context 'when reset link is in ENVs' do
      let(:link) { 'http://l.ch?token=%<token>s' }

      before { allow(ENV).to receive(:fetch).with('PASSWORD_RESET_LINK', any_args).and_return link }

      it 'returns ENV link' do
        expect(reset_link).to eq 'http://l.ch?token=1234'
      end
    end

    context 'when no link is provided' do
      before { allow(ENV).to receive(:fetch).with('PASSWORD_RESET_LINK', any_args).and_return '' }

      it 'returns default link' do
        expect(reset_link).to eq edit_user_password_url(user, reset_password_token: token)
      end
    end
  end
end
