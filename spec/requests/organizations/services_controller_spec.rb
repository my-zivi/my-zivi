# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ServicesController, type: :request do
  describe '#index' do
    let(:perform_request) { get organizations_services_path(format: format) }

    context 'when format is html' do
      let(:format) { :html }

      context 'when an organization administrator is signed in' do
        before do
          sign_in create(:organization_member, :with_admin_subscribed_organization).user
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
          sign_in create(:organization_member, :with_admin_subscribed_organization).user
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

  describe '#confirm' do
    let(:perform_request) { put confirm_organizations_civil_servant_service_path(service.civil_servant, service) }

    let(:organization_administrator) { create(:organization_member, :with_admin_subscribed_organization) }
    let(:service) { civil_servant.services.first }
    let(:civil_servant) do
      create(:civil_servant, :full, :with_service,
             organization: organization_administrator.organization,
             service_traits: %i[unconfirmed],
             service_attributes: {
               beginning: Date.parse('2020-09-07'),
               ending: Date.parse('2020-10-30')
             })
    end

    context 'when an organization administrator is signed in' do
      let(:now) { Date.parse('2020-08-01') }

      before { sign_in organization_administrator.user }

      around do |spec|
        travel_to(now) { spec.run }
      end

      it 'confirms the service and returns a successful response' do
        expect { perform_request }.to(
          change { service.reload.confirmation_date }.from(nil).to(now)
            .and(change(ExpenseSheet, :count).by(2))
        )
        expect(response).to redirect_to organizations_civil_servant_service_path(service.civil_servant, service)
        expect(flash[:success]).to eq I18n.t('organizations.services.confirm.successful_confirm')
      end

      context 'when expense sheets cannot be created' do
        # rubocop:disable RSpec/AnyInstance
        before { allow_any_instance_of(Service).to receive(:confirm!).and_return false }
        # rubocop:enable RSpec/AnyInstance

        it 'returns an error response' do
          perform_request
          expect(response).to be_redirect
          expect(flash[:error]).to eq I18n.t('organizations.services.confirm.erroneous_confirm')
        end
      end
    end

    context 'when a civil servant is signed in' do
      before do
        sign_in create(:civil_servant, :full).user
        perform_request
      end

      it_behaves_like 'unauthorized request'
    end

    context 'when nobody is signed in' do
      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end
    end
  end
end
