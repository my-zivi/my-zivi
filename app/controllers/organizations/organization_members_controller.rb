# frozen_string_literal: true

module Organizations
  class OrganizationMembersController < BaseController
    PERMITTED_ORGANIZATION_MEMBER_PARAMS = [
      :first_name, :last_name, :phone, :organization_role,
      user_attributes: %i[email id]
    ].freeze

    before_action :set_organization_member

    def index; end

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

    def destroy; end

    private

    def set_organization_member
      @organization_member = OrganizationMember.find(params[:id])
    end

    def organization_member_params
      params.require(:organization_member).permit(*PERMITTED_ORGANIZATION_MEMBER_PARAMS)
    end
  end
end
