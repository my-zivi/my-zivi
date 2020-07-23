# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::ServicesController, type: :request do
  describe '#index' do
    let(:perform_request) { get civil_servants_services_path }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an administrator is signed in' do
      let(:organization_admin) { create :organization_member }

      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'unauthorized request'
    end

    context 'when no user is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end

  describe '#show' do
    let(:perform_request) { get civil_servants_service_path(service) }

    let(:service) { create :service }

    context 'when a civil servant is signed in' do
      let(:civil_servant) { service.civil_servant }

      before { sign_in civil_servant.user }

      it 'returns http success' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'when an administrator is signed in' do
      let(:organization_admin) { create :organization_member }

      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'unauthorized request'
    end

    context 'when no user is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
