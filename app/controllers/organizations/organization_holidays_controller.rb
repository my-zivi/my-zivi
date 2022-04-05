# frozen_string_literal: true

module Organizations
  class OrganizationHolidaysController < BaseController
    load_and_authorize_resource
    breadcrumb 'organizations.organizations.index', :edit_organizations_organization
    breadcrumb 'organizations.organization_holidays.index', :organizations_organization_holidays_path

    before_action :new_breadcrumb, only: %i[new create]
    before_action :edit_breadcrumb, only: %i[edit update]

    def index
      @organization_holidays = @organization_holidays.order(beginning: :desc)
    end

    def new; end

    def edit; end

    def create
      build_organization_holiday

      if @organization_holiday.save
        flash[:success] = t('organizations.organization_holidays.update.successful_create')
        redirect_to organizations_organization_holidays_path
      else
        flash.now[:error] = t('organizations.organization_holidays.update.erroneous_create')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @organization_holiday.update(organization_holiday_params)
        flash[:success] = t('organizations.organization_holidays.update.successful_update')
        redirect_to organizations_organization_holidays_path
      else
        flash.now[:error] = t('organizations.organization_holidays.update.erroneous_update')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @organization_holiday.destroy
        flash[:success] = t('organizations.organization_holidays.update.successful_destroy')
        redirect_to organizations_organization_holidays_path
      else
        flash.now[:error] = t('organizations.organization_holidays.update.erroneous_destroy')
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def organization_holiday_params
      params.require(:organization_holiday).permit(:description, :beginning, :ending)
    end

    def build_organization_holiday
      @organization_holiday = current_organization_admin
                              .organization
                              .organization_holidays
                              .build(organization_holiday_params)
    end

    def new_breadcrumb
      breadcrumb 'organizations.organization_holidays.new', :new_organizations_organization_holiday_path
    end

    def edit_breadcrumb
      breadcrumb @organization_holiday.description, :organizations_organization_holiday_path
    end
  end
end
