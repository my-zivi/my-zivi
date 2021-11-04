# frozen_string_literal: true

module Organizations
  class ServiceSpecificationsController < BaseController
    PERMITTED_PARAMS = [
      :name, :internal_note, :work_clothing_expenses,
      :accommodation_expenses, :location, :active, :identification_number,
      :contact_person_id, :lead_person_id,
      { work_days_expenses: %i[breakfast lunch dinner],
        paid_vacation_expenses: %i[breakfast lunch dinner],
        first_day_expenses: %i[breakfast lunch dinner],
        last_day_expenses: %i[breakfast lunch dinner] }
    ].freeze

    load_and_authorize_resource param_method: :service_specification_params

    breadcrumb 'organizations.service_specifications.index', :organizations_service_specifications_path

    before_action :new_breadcrumbs, only: %i[new create]
    before_action :edit_breadcrumbs, only: %i[edit update]

    def index
      @service_specifications = @service_specifications
                                .order(active: :desc, name: :asc)
                                .includes(:contact_person, :lead_person)
    end

    def new
      @service_specification = current_organization_admin.organization.service_specifications.build
    end

    def edit; end

    def create
      if @service_specification.save
        redirect_to organizations_service_specifications_path, notice: t('.successful_create')
      else
        flash.now[:error] = t('.erroneous_create')
        render :new
      end
    end

    def update
      if @service_specification.update(service_specification_params)
        redirect_to edit_organizations_service_specification_path, notice: t('.successful_update')
      else
        flash.now[:error] = t('.erroneous_update')
        render :edit
      end
    end

    def destroy
      if @service_specification.destroy
        flash.now[:notice] = t('.successful_destroy')
      else
        flash.now[:error] = t('.erroneous_destroy')
      end

      redirect_to organizations_service_specifications_path
    end

    private

    def service_specification_params
      params.require(:service_specification).permit(*PERMITTED_PARAMS).tap do |service_specification_params|
        modify_params(service_specification_params)
      end
    end

    # :reek:UtilityFunction
    def modify_params(params)
      %i[work_days_expenses paid_vacation_expenses first_day_expenses last_day_expenses].each do |daily_expense_field|
        params[daily_expense_field]&.transform_values!(&:to_i)
      end
    end

    def new_breadcrumbs
      breadcrumb 'organizations.service_specifications.new', :new_organizations_service_specification_path
    end

    def edit_breadcrumbs
      breadcrumb @service_specification.name, :new_organizations_service_specification_path
    end
  end
end
