# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PaymentsController, type: :request do
  describe '#show' do
    let(:request) { get v1_pain_export_path(format: :xml), params: { token: token } }
    let!(:user) { create :user }

    context 'when a token is provided' do
      let(:token) { generate_jwt_token_for_user(user) }

      let(:beginning) { (Time.zone.today - 3.months).beginning_of_week }
      let(:ending) { (Time.zone.today - 1.week).end_of_week - 2.days }

      before do
        create :expense_sheet, :ready_for_payment, user: user, beginning: beginning, ending: ending
        create :service, user: user, beginning: beginning, ending: ending
      end

      context 'when user is admin' do
        let(:user) { create :user, :admin }

        it_behaves_like 'renders a successful http status code'

        it 'returns a content type xml' do
          request
          expect(response.headers['Content-Type']).to include 'xml'
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
