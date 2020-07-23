# frozen_string_literal: true

module Organizations
  class ServiceSpecificationsController < BaseController
    load_and_authorize_resource

    def index
      @service_specifications = ServiceSpecification.all
    end

    def show; end

    def new
      @service_specification = ServiceSpecification.new
    end

    def edit; end

    def create
      @service_specification = ServiceSpecification.new(service_specification_params)

      if @service_specification.save
        redirect_to @service_specification, notice: 'Service specification was successfully created.'
      else
        render :new
      end
    end

    def update
      if @service_specification.update(service_specification_params)
        redirect_to @service_specification, notice: 'Service specification was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @service_specification.destroy
      redirect_to service_specifications_url, notice: 'Service specification was successfully destroyed.'
    end

    private

    def service_specification_params
      params.fetch(:service_specification, {})
    end
  end
end
