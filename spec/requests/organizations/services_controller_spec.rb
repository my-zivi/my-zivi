# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ServicesController, type: :request do
  describe '#index' do
    let(:perform_request) { get organizations_services_path(format: format) }

    context 'when format is html' do
      let(:format) { :html }

      context 'when an organization administrator is signed in' do
        before do
          sign_in create(:organization_member).user
          perform_request
        end

        it 'renders a successful response' do
          expect(response).to be_successful
          expect(response).to render_template 'organizations/services/index'
        end
      end

      context 'when a civil servant is signed in' do
        before { sign_in create(:civil_servant, :full).user }

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end

      context 'when nobody is signed in' do
        it_behaves_like 'unauthenticated request' do
          before { perform_request }
        end
      end
    end

    context 'when format is json' do
      let(:format) { :json }

      context 'when an organization administrator is signed in' do
        before do
          sign_in create(:organization_member).user
          perform_request
        end

        it 'renders a successful JSON response' do
          expect(response).to be_successful
          expect(response.content_type).to match 'application/json'
          expect(response.body).not_to be_empty
        end
      end

      context 'when a civil servant is signed in' do
        before do
          sign_in create(:civil_servant, :full).user
          perform_request
        end

        it_behaves_like 'unauthorized json request'
      end

      context 'when nobody is signed in' do
        it_behaves_like 'unauthenticated json request' do
          before { perform_request }
        end
      end
    end
  end
end
