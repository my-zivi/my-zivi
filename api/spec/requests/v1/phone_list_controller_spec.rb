# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PhoneListController, type: :request do
  describe '#index' do
    let(:request) { get(v1_phone_list_path(format: :pdf), params: params) }
    let(:beginning) { '2018-11-05' }
    let(:ending) { '2018-11-30' }
    let(:params) do
      {
        token: token,
        phone_list: { beginning: beginning, ending: ending }
      }
    end
    let!(:user) { create :user }

    context 'when a token is provided' do
      let(:token) { generate_jwt_token_for_user(user) }

      before { create :service }

      context 'when user is admin' do
        let(:user) { create :user, :admin }

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type pdf' do
          request
          expect(response.headers['Content-Type']).to include 'pdf'
        end

        context 'when no beginning is provided' do
          subject { -> { request } }

          let(:beginning) { '' }

          it { is_expected.to raise_exception ActionController::ParameterMissing }
        end

        context 'when no ending is provided' do
          subject { -> { request } }

          let(:ending) { '' }

          it { is_expected.to raise_exception ActionController::ParameterMissing }
        end
      end

      context 'when user is civil servant' do
        it_behaves_like 'admin protected resource'
      end
    end

    context 'when no token is provided' do
      subject { -> { request } }

      let(:token) { nil }

      it { is_expected.to raise_exception ActionController::ParameterMissing }
    end

    context 'when an invalid token is provided' do
      let(:token) { 'invalid' }

      it_behaves_like 'admin protected resource'
    end
  end
end
