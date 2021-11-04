# frozen_string_literal: true

module Organizations
  class OrganizationMembersController < BaseController
    PERMITTED_ORGANIZATION_MEMBER_PARAMS = %i[first_name last_name phone organization_role contact_email].freeze

    load_and_authorize_resource
    before_action :set_breadcrumb
    before_action :new_breadcrumbs, only: %i[new create]
    before_action :edit_breadcrumbs, only: %i[edit update]

    def index
      @organization_members = @organization_members.includes(:user)
    end

    def new; end

    def create
      if @organization_member.save
        flash.now[:success] = t('.successfully_created')
        redirect_to organizations_members_path
      else
        flash.now[:error] = t('.erroneous_create')
        render :new
      end
    end

    def edit; end

    def update
      if @organization_member.update(update_params)
        flash.now[:success] = t('.successfully_updated')
        redirect_to edit_organizations_member_path(@organization_member)
      else
        flash.now[:error] = t('.erroneous_update')
        render :edit
      end
    end

    def destroy
      if @organization_member != current_organization_admin && @organization_member.destroy
        flash.now[:success] = t('.successfully_deleted')
        redirect_to organizations_members_path
      else
        flash.now[:error] = t('.erroneous_delete')
        render :edit
      end
    end

    private

    def set_breadcrumb
      return if @organization_member == current_organization_admin

      breadcrumb 'organizations.organization_members.index',
                 organizations_members_path
    end

    def edit_breadcrumbs
      if @organization_member == current_organization_admin
        breadcrumb 'organizations.organization_members.profile', edit_organizations_member_path(@organization_member)
      else
        breadcrumb @organization_member.full_name, edit_organizations_member_path(@organization_member)
      end
    end

    def new_breadcrumbs
      breadcrumb 'organizations.organization_members.new', :new_organizations_member_path
    end

    def create_params
      params.require(:organization_member).permit(*PERMITTED_ORGANIZATION_MEMBER_PARAMS)
    end

    def update_params
      params.require(:organization_member).permit(*PERMITTED_ORGANIZATION_MEMBER_PARAMS, user_attributes: %i[email id])
    end
  end
end
