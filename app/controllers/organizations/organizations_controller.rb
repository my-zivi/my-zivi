# frozen_string_literal: true

module Organizations
  class OrganizationsController < BaseController
    include UsersHelper

    before_action :load_organization

    def edit; end

    private

    def load_organization
      @organization = current_organization
      authorize! action_name.to_sym, @organization
    end
  end
end
