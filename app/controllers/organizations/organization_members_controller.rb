# frozen_string_literal: true

module Organizations
  class OrganizationMembersController < BaseController
    PERMITTED_ORGANIZATION_MEMBER_PARAMS = [
      :first_name, :last_name, :phone, :organization_role,
      user_attributes: %i[email id]
    ].freeze

    include UsersHelper

    load_and_authorize_resource
    skip_load_resource only: :index

    def index
      @organization_members = current_organization_admin.organization.organization_members.includes(:user)
    end

    def edit; end

    def update
      if @organization_member.update(organization_member_params)
        flash[:success] = t('.successfully_updated')
        redirect_to edit_organizations_member_path(@organization_member)
      else
        flash[:error] = t('.erroneous_update')
        render :edit
      end
    end

    def destroy
      if @organization_member != current_organization_admin && @organization_member.destroy
        flash[:success] = t('.successfully_deleted')
        redirect_to organizations_members_path
      else
        flash[:error] = t('.erroneous_delete')
        render :edit
      end
    end

    private

    def organization_member_params
      params.require(:organization_member).permit(*PERMITTED_ORGANIZATION_MEMBER_PARAMS)
    end
  end
end
