# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PhoneListController, type: :request do
  let(:organization) { create :organization }

  context 'when signed in as an organization administrator' do
    let(:organization_administrator) { create :organization_member, organization: organization }

    before { sign_in organization_administrator.user }

    describe '#index' do
      context 'when format is html' do
        before { get organizations_phone_list_path }

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'when format is pdf' do
        before { get organizations_phone_list_path(format: :pdf) }

        it 'returns correct response' do
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq 'application/pdf'
          expect(response.content_length).to be_positive
        end
      end
    end
  end

  context 'when signed in as a civil servant' do
    let(:civil_servant) { create :civil_servant, :full }

    before { sign_in civil_servant.user }

    describe '#index' do
      let(:perform_request) { get organizations_phone_list_path }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end
  end

  context 'when no one is signed in' do
    describe '#index' do
      let(:perform_request) { get organizations_phone_list_path }

      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
