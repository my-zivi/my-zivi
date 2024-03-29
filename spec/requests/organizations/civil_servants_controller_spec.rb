# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::CivilServantsController, type: :request do
  describe '#index' do
    let(:perform_request) { get organizations_civil_servants_path }
    let(:organization) { create :organization, :with_admin }

    before do
      create(:civil_servant, :with_service, :full, first_name: 'Maria')
      create(:civil_servant, :with_service, :full, organization: organization, first_name: 'Peter')
      create(:civil_servant, :with_service, :full,
             organization: organization,
             first_name: 'Paul',
             service_attributes: {
               beginning: '2018-11-05',
               ending: '2018-11-30'
             })
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [I18n.t('loaf.breadcrumbs.organizations.civil_servants.index')]
        end

        before { perform_request }
      end

      it 'successfully fetches a list of civil servants in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'Peter'
        expect(response.body).not_to include 'Maria', 'Paul'
      end

      context 'when inactive services are turned on' do
        let(:perform_request) { get organizations_civil_servants_path(filters: { show_inactive: 'true' }) }

        it 'fetches a list of active and inactive civil servants in the organization' do
          perform_request
          expect(response.body).to include 'Peter', 'Paul'
          expect(response.body).not_to include 'Maria'
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#show' do
    let(:perform_request) { get organizations_civil_servant_path(civil_servant) }

    let(:organization) { create(:organization, :with_admin) }
    let(:civil_servant) { create(:civil_servant, :full, :with_service, organization: organization) }

    context 'when an organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.civil_servants.index'),
            civil_servant.full_name
          ]
        end

        before { perform_request }
      end

      it 'renders the civil servant details page' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'organizations/civil_servants/show'
        expect(response.body).to include civil_servant.full_name
      end

      context 'when requesting a civil servant which has never served the organization' do
        let(:civil_servant) { create(:civil_servant, :full, :with_service) }

        before { perform_request }

        it_behaves_like 'unauthorized request'
      end
    end

    it_behaves_like 'admin subscription route only'
  end
end
