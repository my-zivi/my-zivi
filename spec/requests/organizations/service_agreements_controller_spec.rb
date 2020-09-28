# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ServiceAgreementsController, type: :request do
  describe '#index', :without_bullet do
    let(:perform_request) { get organizations_service_agreements_path }
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:brigitte) { create(:civil_servant, :with_service, :full, first_name: 'Brigitte') }
    let(:peter) { create(:civil_servant, :with_service, :full, first_name: 'Peter') }
    let(:maria) { create(:civil_servant, :full, first_name: 'Maria') }
    let(:paul) { create(:civil_servant, :full, :with_service, first_name: 'Paul') }

    let(:brigitte_service) { brigitte.services.first }
    let(:peter_service) { peter.services.first }
    let(:maria_service) { maria.services.first }
    let(:paul_service) { paul.services.first }

    before do
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_agreed_on: nil,
             organization_agreed: true,
             organization_agreed_on: '2020-01-01')
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it 'successfully fetches a list of service agreements in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'Maria'
        expect(response.body).not_to include 'Brigitte', 'Peter', 'Paul'
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

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

  describe '#destroy' do
    let(:perform_request) { delete organizations_service_agreement_path(maria_service) }
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:maria) { create(:civil_servant, :full, first_name: 'Maria') }
    let(:maria_service) { maria.services.first }

    before do
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_agreed_on: nil,
             organization_agreed: true,
             organization_agreed_on: '2020-01-01')
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create :organization_member, organization: organization }

      before { sign_in organization_administrator.user }

      it 'successfully destroy the service agreement' do
        expect { perform_request }.to change(Service, :count).by(-1)
        expect(flash[:notice]).to eq I18n.t('organizations.service_agreements.destroy.successful_destroy')
        expect(response).to redirect_to organizations_service_agreements_path
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

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
