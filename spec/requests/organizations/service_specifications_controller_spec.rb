# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::ServiceSpecificationsController, type: :request do
  subject { response }

  let(:organization_admin) { create(:organization_member, :with_admin_subscribed_organization) }

  describe '#index' do
    let(:perform_request) { get organizations_service_specifications_path }
    let!(:outside_service_specification) { create(:service_specification) }
    let!(:service_specifications) do
      [
        create(:service_specification, organization: organization_admin.organization, name: 'Wildblumen pflücken'),
        create(:service_specification, organization: organization_admin.organization, name: 'Welt retten')
      ]
    end

    context 'when an organization administrator is signed in' do
      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [I18n.t('loaf.breadcrumbs.organizations.service_specifications.index')]
        end
      end

      it 'renders a list of the organization\'s service specifications successfully' do
        expect(response).to be_successful
        expect(response.body).to include(*service_specifications.map(&:name))
        expect(response.body).not_to include(outside_service_specification.name)
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#new' do
    let(:perform_request) { get new_organizations_service_specification_path }

    context 'when an organization administrator is signed in' do
      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.service_specifications.index'),
            I18n.t('loaf.breadcrumbs.organizations.service_specifications.new')
          ]
        end
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#edit' do
    let(:service_specification) { create :service_specification, organization: organization_admin.organization }
    let(:perform_request) { get edit_organizations_service_specification_path(service_specification) }

    context 'when an organization administrator is signed in' do
      before do
        sign_in organization_admin.user
        perform_request
      end

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.service_specifications.index'),
            service_specification.name
          ]
        end
      end

      it 'render a successful response' do
        expect(response).to be_successful
        expect(response.body).to include(
          I18n.t('organizations.service_specifications.edit.title', name: service_specification.name)
        )
      end

      context 'when trying to access an outside service specification' do
        let(:outside_organization) { create :organization, :with_admin }
        let(:service_specification) { create :service_specification, organization: outside_organization }

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end

  describe '#create' do
    let(:perform_request) { post organizations_service_specifications_path, params: params }
    let(:params) { { service_specification: service_specification_params } }
    let(:created_service_specification) { ServiceSpecification.order(:created_at).last }

    context 'when an organization administrator is signed in' do
      before { sign_in organization_admin.user }

      context 'with valid parameters' do
        let(:service_specification_params) do
          attributes_for(:service_specification).merge(
            lead_person_id: organization_admin.id,
            contact_person_id: organization_admin.id
          )
        end

        it 'creates a new service specification and redirects back to the service specifications list' do
          expect { perform_request }.to change(ServiceSpecification, :count).by(1)
          expect(response).to redirect_to(organizations_service_specifications_path)

          updated_attributes = created_service_specification.slice(service_specification_params.keys).symbolize_keys
          expect(updated_attributes).to eq service_specification_params
        end
      end

      context 'with invalid parameters' do
        let(:service_specification_params) do
          attributes_for(:service_specification).merge(
            name: '',
            location: ''
          )
        end

        let(:expected_error_messages) do
          %i[location name contact_person lead_person].map do |attribute_name|
            blank = I18n.t('errors.messages.blank')
            "#{I18n.t(attribute_name, scope: %i[activerecord attributes service_specification])} #{blank}"
          end
        end

        it 'does not create a new service specification and renders an error' do
          expect { perform_request }.not_to change(ServiceSpecification, :count)
          expect(response).to be_successful
          expect(response).to render_template 'organizations/service_specifications/new'
          expect(response.body).to include(*expected_error_messages)
        end
      end
    end

    it_behaves_like 'admin subscription route only' do
      let(:service_specification_params) do
        attributes_for(:service_specification).merge(
          lead_person_id: organization_admin.id,
          contact_person_id: organization_admin.id
        )
      end
    end
  end

  describe '#update' do
    let(:service_specification) { create :service_specification, organization: organization_admin.organization }
    let(:perform_request) { patch organizations_service_specification_path(service_specification), params: params }
    let(:params) { { service_specification: service_specification_params } }

    context 'when an organization administrator is signed in' do
      before { sign_in organization_admin.user }

      context 'with valid parameters' do
        let(:service_specification_params) do
          {
            name: 'This is my updated name',
            active: false,
            location: 'Bosnia-Herzegovina'
          }
        end

        it 'updates the requested organizations_service_specification' do
          expect { perform_request }.to(
            change { service_specification.reload.slice(service_specification_params.keys) }.to(
              service_specification_params
            )
          )

          expect(response).to redirect_to edit_organizations_service_specification_path
        end

        context 'when trying to update a service specification of an outside organization' do
          let(:outside_organization) { create :organization, :with_admin }
          let(:service_specification) { create :service_specification, organization: outside_organization }

          it_behaves_like 'unauthorized request' do
            before { perform_request }
          end
        end
      end

      context 'with invalid parameters' do
        let(:service_specification_params) do
          {
            work_days_expenses: { breakfast: -200, lunch: 5, dinner: 0 }
          }
        end

        it 'does not update service specification' do
          expect { perform_request }.not_to(change(service_specification, :reload))
          expect(response).to render_template 'organizations/service_specifications/edit'
          expect(flash[:error]).to eq I18n.t('organizations.service_specifications.update.erroneous_update')
        end
      end
    end

    it_behaves_like 'admin subscription route only' do
      let(:service_specification_params) do
        {
          name: 'This is my updated name',
          active: false,
          location: 'Bosnia-Herzegovina'
        }
      end
    end
  end

  describe '#destroy' do
    let(:perform_request) { delete organizations_service_specification_path(service_specification) }
    let!(:service_specification) { create :service_specification, organization: organization_admin.organization }

    context 'when an organization administrator is signed in' do
      before { sign_in organization_admin.user }

      it 'destroys the requested service specification' do
        expect { perform_request }.to change(ServiceSpecification, :count).by(-1)
        expect(flash[:notice]).to eq I18n.t('organizations.service_specifications.destroy.successful_destroy')
        expect(response).to redirect_to organizations_service_specifications_path
      end

      context 'when some services are already associated with the service specification' do
        before { create :service, service_specification: service_specification }

        it 'does not delete the service specification' do
          expect { perform_request }.not_to change(ServiceSpecification, :count)
          expect(flash[:error]).to eq I18n.t('organizations.service_specifications.destroy.erroneous_destroy')
        end
      end

      context 'when trying to destroy ' do
        let(:outside_organization) { create :organization, :with_admin }
        let(:service_specification) { create :service_specification, organization: outside_organization }

        it 'does not delete the service specification' do
          expect { perform_request }.not_to change(ServiceSpecification, :count)
        end

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end
    end

    it_behaves_like 'admin subscription route only'
  end
end
