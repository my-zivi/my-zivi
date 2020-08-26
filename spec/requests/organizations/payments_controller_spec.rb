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
        expect(response).to render_template 'organizations/payments/index'
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
    subject { response }

    let(:organization) { create(:organization) }
    let(:payment) { create(:payment, organization: organization, created_at: '2020-01-01') }
    let(:perform_request) { get organizations_payment_path(payment) }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it 'returns a detail view of the payment' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'organizations/payments/show'
        expect(response.body).to include I18n.t('organizations.payments.show.title', date: '01.01.2020')
      end

      context 'when trying to access a payment from a different organization' do
        let(:payment) { create(:payment) }

        before { perform_request }

        it_behaves_like 'unauthorized request'
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

      before do
        sign_in civil_servant.user
        perform_request
      end

      it_behaves_like 'unauthorized request'
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#update' do
    subject { response }

    let(:organization) { create(:organization) }
    let(:payment) { create(:payment, organization: organization) }
    let(:perform_request) { patch organizations_payment_path(payment, params: { payment: payment_params }) }
    let(:payment_params) { {} }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      context 'with valid state update params' do
        let(:payment_params) { { state: 'paid' } }

        it 'updates the payment' do
          expect { perform_request }.to(change { payment.reload.state }.and(change { payment.reload.paid_timestamp }))
          expect(response).to have_http_status(:found)
          expect(flash[:success]).to eq I18n.t('organizations.payments.update.successful_update')
        end

        context 'when accessing a foreign payment' do
          let(:payment) { create(:payment) }

          it_behaves_like 'unauthorized request' do
            before { perform_request }
          end

          it 'does not touch the payment' do
            expect { perform_request }.not_to(change(payment, :reload))
          end
        end
      end

      context 'with invalid state update params' do
        let(:payment_params) { { state: 'open' } }
        let(:payment) { create(:payment, :paid, organization: organization) }

        it 'does not update' do
          expect { perform_request }.not_to(change(payment, :reload))
          expect(flash[:error]).to eq I18n.t('organizations.payments.update.erroneous_update')
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
