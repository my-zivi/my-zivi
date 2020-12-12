# frozen_string_literal: true

module Organizations
  class OrganizationsController < BaseController
    include UsersHelper

    before_action :load_organization

    def edit; end

    def update
      if @organization.update(organization_params)
        flash[:success] = t('organizations.organizations.update.successful_update')
        redirect_to edit_organizations_organization_path
      else
        flash[:error] = t('organizations.organizations.update.erroneous_update')
        render :edit
      end
    end

    private

    def load_organization
      @organization = current_organization
      authorize! action_name.to_sym, @organization
    end

    def organization_params
      params.require(:organization)
            .permit(:name, :identification_number,
                    address_attributes: %i[primary_line secondary_line supplement street city zip],
                    creditor_detail_attributes: %i[iban bic])
    end
  end
end
