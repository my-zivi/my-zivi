# frozen_string_literal: true

module Organizations
  class ServiceSpecificationsController < BaseController
    PERMITTED_PARAMS = [
      :name, :internal_note, :work_clothing_expenses,
      :accommodation_expenses, :location, :active, :identification_number,
      work_days_expenses: %i[breakfast lunch dinner],
      paid_vacation_expenses: %i[breakfast lunch dinner],
      first_day_expenses: %i[breakfast lunch dinner],
      last_day_expenses: %i[breakfast lunch dinner]
    ].freeze

    load_and_authorize_resource

    def index
      @service_specifications = @service_specifications
                                .order(active: :desc, name: :asc)
                                .includes(:contact_person, :lead_person)
    end

    def new; end

    def edit; end

    def create
      if @service_specification.save
        redirect_to @service_specification, notice: t('.successful_create')
      else
        flash[:error] = t('.erroneous_create')
        render :new
      end
    end

    def update
      if @service_specification.update(service_specification_params)
        redirect_to edit_organizations_service_specification_path, notice: t('.successful_update')
      else
        flash[:error] = t('.erroneous_update')
        render :edit
      end
    end

    def destroy
      @service_specification.destroy
      redirect_to service_specifications_url, notice: t('.successful_destroy')
    end

    private

    def service_specification_params
      params.require(:service_specification).permit(*PERMITTED_PARAMS).tap(&method(:modify_params))
    end

    def modify_params(params)
      %i[work_days_expenses paid_vacation_expenses first_day_expenses last_day_expenses].each do |daily_expense_field|
        params[daily_expense_field].transform_values!(&:to_i)
      end
    end
  end
end
