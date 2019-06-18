# frozen_string_literal: true

module V1
  class ServicesController < APIController
    include V1::Concerns::AdminAuthorizable

    PERMITTED_SERVICE_PARAMS = %i[
      user_id service_specification_id
      beginning ending confirmation_date
      service_type first_swo_service long_service probation_service
      feedback_mail_sent
    ].freeze

    before_action :set_service, only: %i[show update destroy]
    before_action :protect_foreign_resource!, except: %i[index create], unless: -> { current_user.admin? }
    before_action :authorize_admin!, only: :index

    def index
      @services = Service.all
    end

    def show; end

    def create
      @service = Service.new(service_params)

      raise ValidationError, @service.errors unless @service.save

      render :show, status: :created
    end

    def update
      raise ValidationError, @service.errors unless @service.update(service_params)

      render :show
    end

    def destroy
      raise ValidationError, @service.errors unless @service.destroy
    end

    private

    def protect_foreign_resource!
      raise AuthorizationError unless @service.user.id == current_user.id
    end

    def set_service
      @service = Service.find(params[:id])
    end

    def service_params
      permitted_params = params.require(:service).permit(*PERMITTED_SERVICE_PARAMS).to_h
      permitted_params[:user_id] = current_user.id unless current_user.admin?

      permitted_params
    end
  end
end
