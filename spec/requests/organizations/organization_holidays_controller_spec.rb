# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OrganizationHolidaysController, :without_bullet, type: :request do
  describe '#index' do
    let(:perform_request) { get organizations_organization_holidays_path }
    let(:organization) { create(:organization, :with_admin) }
    let(:other_organization_holiday) { create(:organization_holiday) }
    let!(:organization_holidays) do
      [
        create(:organization_holiday, organization: organization, description: 'Weihnachten'),
        create(:organization_holiday, organization: organization, description: 'Offene Türe')
      ]
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it 'successfully fetches a list of organization holidays in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include other_organization_holiday.description
        expect(response.body).to include(
          organization_holidays.first.description,
          organization_holidays.second.description
        )
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

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

  describe '#edit' do
    let(:organization) { create(:organization, :with_admin) }
    let(:organization_holiday) { create(:organization_holiday, organization: organization) }
    let(:perform_request) { get edit_organizations_organization_holiday_path(organization_holiday) }

    context 'when an organization admin is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it 'renders the edit form for the organization holiday' do
        perform_request
        expect(response).to have_http_status(:ok)
        expect(response.body).to include organization_holiday.description
        expect(response).to render_template 'organizations/organization_holidays/edit'
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

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

  describe '#new' do
    let(:perform_request) { get new_organizations_organization_holiday_path }

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, :with_admin_subscribed_organization) }

      before { sign_in organization_administrator.user }

      it 'successfully renders the form' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'organizations/organization_holidays/new'
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

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

  describe '#create' do
    let(:perform_request) { post organizations_organization_holidays_path, params: params }
    let(:params) { {} }

    context 'when an organization admin is signed in' do
      let(:organization_administrator) { create(:organization_member, :with_admin_subscribed_organization) }

      before { sign_in organization_administrator.user }

      context 'with valid params' do
        let(:params) { { organization_holiday: organization_holiday_params } }
        let(:organization_holiday_params) do
          {
            description: 'My new organization holiday',
            beginning: Date.new(2020, 1, 1),
            ending: Date.new(2020, 1, 20)
          }
        end

        it 'creates the organization holiday and renders success message' do
          expect { perform_request }.to(
            change { organization_administrator.organization.organization_holidays.reload.count }.by(1)
          )

          expect(flash[:success]).to eq I18n.t('organizations.organization_holidays.update.successful_create')
          expect(response).to redirect_to organizations_organization_holidays_path
        end
      end

      context 'with invalid params' do
        let(:params) { { organization_holiday: { ending: '' } } }

        it 'does not create the organization holiday and renders error message' do
          expect { perform_request }.not_to change(OrganizationHoliday, :count)
          expect(flash[:error]).to eq I18n.t('organizations.organization_holidays.update.erroneous_create')
          expect(response).to render_template 'organizations/organization_holidays/new'
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

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
    let(:organization) { create(:organization, :with_admin) }
    let(:organization_holiday) { create(:organization_holiday, organization: organization) }
    let(:perform_request) { patch organizations_organization_holiday_path(organization_holiday), params: params }
    let(:params) { {} }

    context 'when an organization admin is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      context 'with valid params' do
        let(:params) { { organization_holiday: organization_holiday_params } }
        let(:organization_holiday_params) do
          {
            description: 'My updated organization holiday',
            beginning: Date.new(2020, 1, 1),
            ending: Date.new(2020, 1, 20)
          }
        end

        it 'updates the organization holiday and renders success message' do
          expect { perform_request }.to(
            change { organization_holiday.reload.attributes.symbolize_keys.slice(*organization_holiday_params.keys) }
              .to(organization_holiday_params)
          )

          expect(flash[:success]).to eq I18n.t('organizations.organization_holidays.update.successful_update')
          expect(response).to redirect_to organizations_organization_holidays_path
        end

        context 'when the organization holiday is from a different organization' do
          let(:organization_holiday) { create(:organization_holiday) }

          it_behaves_like 'unauthorized request' do
            before { perform_request }
          end
        end
      end

      context 'with invalid params' do
        let(:params) { { organization_holiday: { ending: '' } } }

        it 'does not update the organization holiday and renders error message' do
          expect { perform_request }.not_to change(organization, :reload)
          expect(flash[:error]).to eq I18n.t('organizations.organization_holidays.update.erroneous_update')
          expect(response).to render_template 'organizations/organization_holidays/edit'
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

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

  describe '#destroy' do
    let(:perform_request) { delete organizations_organization_holiday_path(organization_holiday) }
    let(:organization) { create(:organization, :with_admin) }
    let!(:organization_holiday) { create(:organization_holiday, :in_future, organization: organization) }

    context 'when an organization admin is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it 'deletes the organization holiday and renders success message' do
        expect { perform_request }.to(change(OrganizationHoliday, :count).by(-1))

        expect(flash[:success]).to eq I18n.t('organizations.organization_holidays.update.successful_destroy')
        expect(response).to redirect_to organizations_organization_holidays_path
      end

      context 'when the organization holiday cannot be destroyed' do
        let(:organization_holiday) { create(:organization_holiday, organization: organization) }

        it 'does not create the organization holiday and renders error message' do
          expect { perform_request }.not_to change(OrganizationHoliday, :count)
          expect(flash[:error]).to eq I18n.t('organizations.organization_holidays.update.erroneous_destroy')
          expect(response).to render_template 'organizations/organization_holidays/edit'
        end
      end

      context 'when the organization holiday is from a different organization' do
        let(:organization_holiday) { create(:organization_holiday, :in_future) }

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

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
