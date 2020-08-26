# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PaymentsController, type: :request do
  describe '#index' do
    subject { response }

    let(:perform_request) { get organizations_payments_path }
    let(:organization) { create :organization }
    let!(:payments) { create_pair(:payment, organization: organization) }
    let!(:outside_payment) { create(:payment, created_at: '2020-01-01') }

    around do |spec|
      I18n.with_locale(:de) { spec.run }
    end

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include I18n.l(payments.first.created_at.to_date)
        expect(response.body).not_to include I18n.l(outside_payment.created_at.to_date)
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when no one is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#show' do
    it 'returns http success' do
      get '/organizations/payments/show'
      expect(response).to have_http_status(:success)
    end
  end
end
