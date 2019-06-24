# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :request do
  let(:user) { create :user }

  describe '#show' do
    let(:requested_user) { user }
    let(:request) { get v1_user_path(requested_user) }
    let(:expected_successful_response_json) do
      extract_to_json(requested_user).except(
        :created_at, :encrypted_password,
        :reset_password_sent_at, :reset_password_token,
        :updated_at
      )
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in user }

      context 'when he requests himself' do
        it_behaves_like 'renders a successful http status code'

        it 'renders user' do
          request
          expect(parse_response_json(response)).to include expected_successful_response_json
        end
      end

      context 'when he requests a different user than himself' do
        let(:requested_user) { create :user }

        it_behaves_like 'admin protected resource'
      end
    end

    context 'when an admin is logged in' do
      let(:user) { create :user, :admin }

      before { sign_in user }

      context 'when he requests a different user' do
        let(:requested_user) { create :user }

        it_behaves_like 'renders a successful http status code'

        it 'renders user' do
          request
          expect(parse_response_json(response)).to include expected_successful_response_json
        end
      end

      context 'when he requests a different user' do
        let(:request) { get v1_user_path(-1) }

        it_behaves_like 'renders a not found error response'
      end
    end
  end

  describe '#index' do
    let!(:user) { create :user }
    let!(:admin_user) { create :user, :admin }
    let(:request) { get v1_users_path }
    let(:expected_successful_response_json) do
      [user, admin_user].map do |current_user|
        extract_to_json(current_user)
          .merge(services: [])
          .except(
            :created_at, :encrypted_password,
            :reset_password_sent_at, :reset_password_token,
            :updated_at
          )
      end
    end

    context 'when no user is logged in' do
      it_behaves_like 'login protected resource'
    end

    context 'when a civil servant is logged in' do
      before { sign_in user }

      it_behaves_like 'admin protected resource'
    end

    context 'when an admin is logged in' do
      subject { parse_response_json(response) }

      before do
        sign_in admin_user
        request
      end

      it_behaves_like 'renders a successful http status code'

      it { is_expected.to include(*expected_successful_response_json) }
    end
  end
end
