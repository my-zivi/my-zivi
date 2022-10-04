# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::ServiceAgreementsController, type: :request do
  describe '#index', :without_bullet do
    let(:perform_request) { get civil_servants_service_agreements_path }

    let(:civil_servant) { create(:civil_servant, :full, first_name: 'Brigitte') }

    let(:service_agreement) do
      create(:service, :future, :civil_servant_agreement_pending, civil_servant: civil_servant)
    end
    let(:service_definitive) { create(:service, :past, civil_servant: civil_servant) }

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when a civil servant is signed in' do
      before do
        sign_in civil_servant.user
        service_agreement
        service_definitive
      end

      it 'successfully fetches a list of service agreements of the civil servant' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include(I18n.l(service_agreement.beginning), I18n.l(service_agreement.ending),
                                         service_agreement.service_specification.name,
                                         service_agreement.organization.name)
        expect(response.body).not_to include(I18n.l(service_definitive.beginning), I18n.l(service_definitive.ending))
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#accept' do
    let(:perform_request) { patch civil_servants_service_agreement_accept_path(service_agreement) }

    let(:civil_servant) { create(:civil_servant, :full, first_name: 'Brigitte') }
    let(:service_agreement) do
      create(:service, :future, :civil_servant_agreement_pending, civil_servant: civil_servant)
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when a civil servant is signed in' do
      before { sign_in civil_servant.user }

      context 'when the service is unaccpected' do
        let(:service_agreement) do
          create(:service, :future, :civil_servant_agreement_pending, civil_servant: civil_servant)
        end

        it 'successfully accpets the service' do
          expect { perform_request }.to(change { service_agreement.reload.civil_servant_agreed }.from(nil).to(true))
          expect(response).to redirect_to(civil_servants_service_agreements_path)
          expect(flash[:notice]).to eq I18n.t('civil_servants.service_agreements.accept.successful_accept')
        end
      end

      context 'when the service is already declined' do
        let(:service_agreement) { create(:service, :future, civil_servant_agreed: false, civil_servant: civil_servant) }

        it 'does not change the decided at date' do
          expect { perform_request }.not_to(change { service_agreement.reload.civil_servant_decided_at })
          expect(response).to redirect_to(civil_servants_service_agreements_path)
          expect(flash[:error]).to(
            eq(
              "#{I18n.t('civil_servants.service_agreements.accept.erroneous_accept')}" \
              "#{I18n.t('activerecord.attributes.service.civil_servant_agreed')} " \
              "#{I18n.t('activerecord.errors.models.service.attributes.civil_servant_agreed.already_decided')}"
            )
          )
        end
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#decline' do
    let(:perform_request) { patch civil_servants_service_agreement_decline_path(service_agreement) }

    let(:civil_servant) { create(:civil_servant, :full, first_name: 'Brigitte') }
    let(:service_agreement) do
      create(:service, :future,
             :civil_servant_agreement_pending, civil_servant: civil_servant)
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when a civil servant is signed in' do
      before { sign_in civil_servant.user }

      context 'when the service is unaccpected' do
        let(:service_agreement) do
          create(:service, :future,
                 :civil_servant_agreement_pending, civil_servant: civil_servant)
        end

        it 'successfully declines the service' do
          expect { perform_request }.to(change { service_agreement.reload.civil_servant_agreed }.from(nil).to(false))
          expect(response).to redirect_to(civil_servants_service_agreements_path)
          expect(flash[:notice]).to eq I18n.t('civil_servants.service_agreements.decline.successful_decline')
        end
      end

      context 'when the service is already accepted' do
        let(:service_agreement) { create(:service, :future, civil_servant: civil_servant) }

        it 'does not change the decided at date' do
          expect { perform_request }.not_to(change { service_agreement.reload.civil_servant_decided_at })
          expect(response).to redirect_to(civil_servants_service_agreements_path)
          expect(flash[:error]).to(
            eq(
              "#{I18n.t('civil_servants.service_agreements.decline.erroneous_decline')}" \
              "#{I18n.t('activerecord.attributes.service.civil_servant_agreed')} " \
              "#{I18n.t('activerecord.errors.models.service.attributes.civil_servant_agreed.already_decided')}"
            )
          )
        end
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
