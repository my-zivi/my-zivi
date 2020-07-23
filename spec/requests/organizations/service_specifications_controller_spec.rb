# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ServiceSpecificationsController, type: :request do
  subject { response }

  context 'when an organization administrator is signed in' do
    let(:organization_admin) { create :organization_member }

    before { sign_in organization_admin.user }

    describe '#index' do
      let(:perform_request) { get organizations_service_specifications_path }
      let!(:outside_service_specification) { create(:service_specification) }
      let!(:service_specifications) do
        [
          create(:service_specification, organization: organization_admin.organization, name: 'Wildblumen pflücken'),
          create(:service_specification, organization: organization_admin.organization, name: 'Welt retten')
        ]
      end

      before { perform_request }

      it 'renders a list of the organization\'s service specifications successfully' do
        expect(response).to be_successful
        expect(response.body).to include(*service_specifications.map(&:name))
        expect(response.body).not_to include(outside_service_specification.name)
      end
    end

    describe '#new' do
      let(:perform_request) { get new_organizations_service_specification_path }

      before { perform_request }

      it 'renders a successful response' do
        expect(response).to be_successful
      end
    end

    describe '#edit' do
      let(:service_specification) { create :service_specification, organization: organization_admin.organization }
      let(:perform_request) { get edit_organizations_service_specification_path(service_specification) }

      before { perform_request }

      it 'render a successful response' do
        expect(response).to be_successful
        expect(response.body).to include(
          I18n.t('organizations.service_specifications.edit.title', name: service_specification.name)
        )
      end
    end

    describe '#create' do
      let(:perform_request) { post organizations_service_specifications_path, params: params }
      let(:params) { { service_specification: service_specification_params } }
      let(:created_service_specification) { ServiceSpecification.order(:created_at).last }

      context 'with valid parameters' do
        let(:service_specification_params) do
          attributes_for(:service_specification).merge(
            lead_person_id: organization_admin.id,
            contact_person_id: organization_admin.id
          )
        end

        it 'creates a new ServiceSpecification and redirects back to the service specifications list' do
          expect { perform_request }.to change(ServiceSpecification, :count).by(1)
          expect(response).to redirect_to(organizations_service_specifications_path)

          updated_attributes = created_service_specification.slice(service_specification_params.keys).symbolize_keys
          expect(updated_attributes).to eq service_specification_params
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new ServiceSpecification' do
          expect do
            post organizations_service_specifications_url, params: { organizations_service_specification: invalid_attributes }
          end.to change(ServiceSpecification, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          post organizations_service_specifications_url, params: { organizations_service_specification: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          skip('Add a hash of attributes valid for your model')
        end

        it 'updates the requested organizations_service_specification' do
          service_specification = ServiceSpecification.create! valid_attributes
          patch organizations_service_specification_url(organizations_service_specification), params: { organizations_service_specification: new_attributes }
          service_specification.reload
          skip('Add assertions for updated state')
        end

        it 'redirects to the organizations_service_specification' do
          service_specification = ServiceSpecification.create! valid_attributes
          patch organizations_service_specification_url(organizations_service_specification), params: { organizations_service_specification: new_attributes }
          service_specification.reload
          expect(response).to redirect_to(organizations_service_specification_url(service_specification))
        end
      end

      context 'with invalid parameters' do
        it "renders a successful response (i.e. to display the 'edit' template)" do
          service_specification = ServiceSpecification.create! valid_attributes
          patch organizations_service_specification_url(organizations_service_specification), params: { organizations_service_specification: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested organizations_service_specification' do
        service_specification = ServiceSpecification.create! valid_attributes
        expect do
          delete organizations_service_specification_url(organizations_service_specification)
        end.to change(ServiceSpecification, :count).by(-1)
      end

      it 'redirects to the organizations_service_specifications list' do
        service_specification = ServiceSpecification.create! valid_attributes
        delete organizations_service_specification_url(organizations_service_specification)
        expect(response).to redirect_to(organizations_service_specifications_url)
      end
    end
  end
end
