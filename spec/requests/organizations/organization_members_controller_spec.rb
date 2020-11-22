# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OrganizationMembersController, type: :request do
  context 'when a organization admin is signed in' do
    let(:organization) { create :organization }
    let(:organization_admin) { create :organization_member, organization: organization }

    before { sign_in organization_admin.user }

    describe '#index' do
      subject { response }

      let(:outside_organization) { create :organization }
      let(:perform_request) { get organizations_members_path }
      let!(:outside_organization_member) do
        create(:organization_member,
               :without_login,
               organization: outside_organization,
               first_name: 'Outside',
               last_name: 'Organization Collaborator')
      end

      before do
        create(:organization_member, :without_login, organization: organization)
        perform_request
      end

      it 'returns a list of organization members inside the organization' do
        expect(response).to be_successful
        expect(response.body).to include(*organization.organization_members.pick(:first_name, :last_name))
        expect(response.body).not_to include(
          outside_organization_member.first_name,
          outside_organization_member.last_name
        )
      end
    end

    describe '#new' do
      before { get new_organizations_member_path }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template 'organizations/organization_members/new'
      end
    end

    describe '#create' do
      let(:perform_request) { post organizations_members_path(organization_member: organization_member_params) }
      let(:organization_member_params) { attributes_for(:organization_member, :without_login) }
      let(:created_organization_member_attributes) do
        OrganizationMember.order(:created_at).last.attributes.slice(*organization_member_params.keys.map(&:to_s))
      end

      it 'creates a new organization member' do
        expect { perform_request }.to change { organization.organization_members.count }.by(1)
        expect(response).to redirect_to organizations_members_path
        expect(flash[:success]).to eq I18n.t('organizations.organization_members.create.successfully_created')
        expect(created_organization_member_attributes).to eq organization_member_params.with_indifferent_access
      end

      context 'when params are invalid' do
        let(:organization_member_params) { { first_name: 'This member is not valid' } }

        it 'does not create a new organization member' do
          expect { perform_request }.not_to change(OrganizationMember, :count)
          expect(response).to render_template 'organizations/organization_members/new'
          expect(flash[:error]).to eq I18n.t('organizations.organization_members.create.erroneous_create')
        end
      end
    end

    describe '#edit' do
      let(:editing_organization_member) { organization_admin }
      let(:perform_request) { get edit_organizations_member_path(editing_organization_member) }

      before { perform_request }

      it 'renders the form' do
        expect(response).to be_successful
        expect(response).to render_template 'organizations/organization_members/edit'
      end

      context 'when the currently signed in organization admin is not in the organization of the resource' do
        let(:other_organization) { create :organization }
        let(:editing_organization_member) do
          create(:organization_member, :without_login, organization: other_organization)
        end

        it_behaves_like 'unauthorized request'
      end
    end

    describe '#update' do
      let(:updating_organization_member) { organization_admin }
      let(:perform_request) do
        patch organizations_member_path(updating_organization_member, params: { organization_member: update_params })
      end

      let(:update_params) do
        {
          first_name: 'Lara',
          last_name: 'Croft',
          phone: '0448674567',
          organization_role: 'NPC Character'
        }
      end

      it 'updates the organization member' do
        expect { perform_request }.to(change { organization_admin.reload.slice(update_params.keys) }.to(update_params))
        expect(flash[:success]).to eq I18n.t('organizations.organization_members.update.successfully_updated')
        expect(response).to redirect_to edit_organizations_member_path(organization_admin)
      end

      context 'when updating the email address' do
        let(:update_params) do
          { user_attributes: { email: 'my.new.email@example.com', id: organization_admin.user.id } }
        end

        it 'sends a confirmation email' do
          expect { perform_request }.to(change { ActionMailer::Base.deliveries.length })
        end
      end

      context 'when updating a different organization member of the same organization' do
        let(:updating_organization_member) { create :organization_member, :without_login, organization: organization }
        let(:update_params) { { first_name: 'Updated name' } }

        it 'updates the user' do
          expect { perform_request }.to(change { updating_organization_member.reload.first_name }.to('Updated name'))
        end
      end

      context 'when updating a different organization member of a different organization' do
        let(:other_organization) { create :organization }
        let(:updating_organization_member) { create :organization_member, organization: other_organization }
        let(:update_params) { { first_name: 'Updated name' } }

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end

        it 'does not change the other organization member' do
          expect { perform_request }.not_to(change { updating_organization_member.reload.first_name })
        end

        context 'when updating the email address' do
          let(:update_params) do
            { user_attributes: { email: 'other@example.com', id: updating_organization_member.user.id } }
          end

          it 'does not send a confirmation email' do
            expect { perform_request }.not_to(change { ActionMailer::Base.deliveries })
          end
        end
      end

      context 'when updating with invalid data' do
        let(:update_params) { { first_name: '' } }

        it 'does not touch the user and renders an error message' do
          expect { perform_request }.not_to(change(organization_admin, :reload))
          expect(flash[:error]).to eq I18n.t('organizations.organization_members.update.erroneous_update')
        end
      end
    end

    describe '#destroy' do
      let(:deleting_user) { create :organization_member, :without_login, organization: organization }
      let(:perform_request) { delete organizations_member_path(deleting_user) }

      before { deleting_user }

      it 'deletes the organization member' do
        expect { perform_request }.to(change(OrganizationMember, :count).by(-1))
        expect(flash[:success]).to eq I18n.t('organizations.organization_members.destroy.successfully_deleted')
        expect(response).to redirect_to organizations_members_path
      end

      context 'when trying to delete an organization member of a different organization' do
        let(:other_organization) { create :organization }
        let(:deleting_user) { create(:organization_member, :without_login, organization: other_organization) }

        it_behaves_like 'unauthorized request' do
          before { perform_request }
        end

        it 'does not delete the organization member' do
          expect { perform_request }.not_to(change(OrganizationMember, :count))
        end
      end

      context 'when trying to delete the currently signed in organization administrator' do
        let(:deleting_user) { organization_admin }

        it 'prevents deletion' do
          expect { perform_request }.not_to(change(OrganizationMember, :count))
          expect(flash[:error]).to eq I18n.t('organizations.organization_members.destroy.erroneous_delete')
        end
      end
    end
  end

  context 'when no user is signed in' do
    describe '#index' do
      let(:perform_request) { get organizations_members_path }

      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end

    describe '#new' do
      let(:perform_request) { get new_organizations_member_path }

      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end

    describe '#create' do
      let(:perform_request) { post organizations_members_path(organization_member: organization_member_params) }
      let(:organization_member_params) { attributes_for(:organization_member, :without_login) }

      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end

      it 'does not create a new organization member' do
        expect { perform_request }.not_to change(OrganizationMember, :count)
      end
    end

    describe '#edit' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { get edit_organizations_member_path(organization_member) }

      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end

    describe '#update' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { patch organizations_member_path(organization_member, params: {}) }

      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end

      it 'does not touch the organization member' do
        expect { perform_request }.not_to(change(organization_member, :reload))
      end
    end

    describe '#destroy' do
      let!(:organization_member) { create :organization_member }
      let(:perform_request) { delete organizations_member_path(organization_member) }

      it_behaves_like 'unauthenticated request' do
        before { perform_request }
      end

      it 'does not destroy the organization member' do
        expect { perform_request }.not_to(change(OrganizationMember, :count))
      end
    end
  end

  context 'when a civil servant is signed in' do
    let(:civil_servant) { create :civil_servant, :full }
    let(:organization_member) { create :organization_member }

    before { sign_in civil_servant.user }

    describe '#index' do
      let(:perform_request) { get organizations_members_path }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end

    describe '#new' do
      let(:perform_request) { get new_organizations_member_path }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end

    describe '#create' do
      let(:perform_request) { post organizations_members_path(organization_member: organization_member_params) }
      let(:organization_member_params) { attributes_for(:organization_member, :without_login) }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end

      it 'does not create a new organization member' do
        expect { perform_request }.not_to change(OrganizationMember, :count)
      end
    end

    describe '#edit' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { get edit_organizations_member_path(organization_member) }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end

    describe '#update' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { patch organizations_member_path(organization_member) }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end

    describe '#destroy' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { delete organizations_member_path(organization_member) }

      before { perform_request }

      it_behaves_like 'unauthorized request'
    end
  end
end
