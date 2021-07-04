# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OrganizationsController, :without_bullet, type: :request do
  describe '#edit' do
    let(:perform_request) { get edit_organizations_organization_path }

    context 'when an organization admin is signed in' do
      let(:organization_administrator) { create(:organization_member) }
      let(:organization) { organization_administrator.organization }

      before { sign_in organization_administrator.user }

      it 'renders the edit form for the organization administrators organization' do
        perform_request
        expect(response).to have_http_status(:ok)
        expect(response.body).to include organization.name
        expect(response).to render_template 'organizations/organizations/edit'
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when no user is signed in' do
      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end
    end
  end

  describe '#update' do
    let(:perform_request) { patch organizations_organization_path, params: params }
    let(:params) { {} }

    context 'when an organization admin is signed in' do
      let(:organization_administrator) { create(:organization_member) }
      let(:organization) { organization_administrator.organization }

      before { sign_in organization_administrator.user }

      context 'with valid params' do
        let(:organization_params) do
          {
            name: 'My new organization',
            identification_number: '1234',
            icon: attributes_for(:organization, :with_icon)[:icon]
          }
        end

        let(:address_params) { attributes_for(:address, :organization) }
        let(:expected_address_params) { address_params.transform_values { |v| v || '' } }
        let(:creditor_detail_params) { { iban: 'CH2889144435336993956', bic: 'ZKBKCHZZ80A' } }
        let(:params) do
          {
            organization: organization_params.merge(
              address_attributes: address_params,
              creditor_detail_attributes: creditor_detail_params
            )
          }
        end

        it 'updates the organization and renders success message' do
          expect { perform_request && organization.reload }.to(
            change { organization.slice(organization_params.keys) }
              .to(**organization_params, icon: be_a(ActiveStorage::Attached::One)).and(
                change { organization.address.slice(address_params.keys) }.to(expected_address_params).and(
                  change { organization.creditor_detail.slice(creditor_detail_params.keys) }.to(creditor_detail_params)
                )
              )
          )

          expect(flash[:success]).to eq I18n.t('organizations.organizations.update.successful_update')
          expect(response).to redirect_to edit_organizations_organization_path
        end
      end

      context 'with invalid params' do
        let(:params) { { organization: { name: '' } } }

        it 'does not update the organization and renders error message' do
          expect { perform_request }.not_to change(organization, :reload)
          expect(flash[:error]).to eq I18n.t('organizations.organizations.update.erroneous_update')
          expect(response).to render_template 'organizations/organizations/edit'
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create :civil_servant, :full }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when no user is signed in' do
      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end
    end
  end
end
