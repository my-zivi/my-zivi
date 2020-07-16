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

    describe '#edit' do
      let(:perform_request) { get edit_organizations_member_path(organization_admin) }

      before { perform_request }

      it 'renders the form' do
        expect(response).to be_successful
        expect(response).to render_template 'organizations/organization_members/edit'
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

        it 'does not change the other organization member' do
          pending 'Uncomment after authorization is implemented'
          expect { perform_request }.not_to(change { updating_organization_member.reload.first_name })
        end

        context 'when updating the email address' do
          let(:update_params) do
            { user_attributes: { email: 'other@example.com', id: updating_organization_member.user.id } }
          end

          it 'does not send a confirmation email' do
            pending 'Uncomment after authorization is implemented'
            expect { perform_request }.not_to(change { ActionMailer::Base.deliveries })
          end
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

        it 'does not delete the organization member' do
          pending 'Unskip after authorization is implemented'
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

      it_behaves_like 'unauthenticated request'
    end

    describe '#edit' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { get edit_organizations_member_path(organization_member) }

      it_behaves_like 'unauthenticated request'
    end

    describe '#update' do
      let(:organization_member) { create :organization_member }
      let(:perform_request) { patch organizations_member_path(organization_member, params: {}) }

      it_behaves_like 'unauthenticated request'

      it 'does not touch the organization member' do
        expect { perform_request }.not_to(change(organization_member, :reload))
      end
    end

    describe '#destroy' do
      let!(:organization_member) { create :organization_member }
      let(:perform_request) { delete organizations_member_path(organization_member) }

      it_behaves_like 'unauthenticated request'

      it 'does not destroy the organization member' do
        expect { perform_request }.not_to(change(OrganizationMember, :count))
      end
    end
  end
end
