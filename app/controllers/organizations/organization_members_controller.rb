# frozen_string_literal: true

module Organizations
  class OrganizationMembersController < BaseController
    PERMITTED_ORGANIZATION_MEMBER_PARAMS = %i[first_name last_name phone organization_role contact_email].freeze

    include UsersHelper

    load_and_authorize_resource

    def index
      @organization_members = @organization_members.includes(:user)
    end

    def create
      if @organization_member.save
        flash[:success] = t('.successfully_created')
        redirect_to organizations_members_path
      else
        flash[:error] = t('.erroneous_create')
        render :new
      end
    end

    def edit; end

    def update
      if @organization_member.update(update_params)
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

    def create_params
      params.require(:organization_member).permit(*PERMITTED_ORGANIZATION_MEMBER_PARAMS)
    end

    def update_params
      params.require(:organization_member).permit(*PERMITTED_ORGANIZATION_MEMBER_PARAMS, user_attributes: %i[email id])
    end
  end
end
