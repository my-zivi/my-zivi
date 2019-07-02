# frozen_string_literal: true

module V1
  class ServicesController < APIController
    include V1::Concerns::AdminAuthorizable

    PERMITTED_SERVICE_SPECIFICATION_PARAMS = %i[service_specification_identification_number].freeze
    PERMITTED_SERVICE_PARAMS = %i[
      user_id beginning ending confirmation_date service_type
      first_swo_service long_service probation_service
      feedback_mail_sent
    ].freeze

    before_action :set_service, only: %i[show update destroy]
    before_action :protect_foreign_resource!, except: %i[index create], unless: -> { current_user.admin? }
    before_action :authorize_admin!, only: :index

    def index
      year = filter_params[:year]
      @services = year.present? ? Service.at_year(year.to_i) : Service.all
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

    def filter_params
      params.permit(:year)
    end

    def service_params
      sanitize_service_params(params.require(:service).permit(*PERMITTED_SERVICE_PARAMS).to_h)
    end

    def sanitize_service_params(permitted_params)
      permitted_params[:user_id] = current_user.id unless current_user.admin?
      permitted_params.except!(:confirmation_date) unless current_user.admin?

      associate_service_specification(permitted_params)
    end

    def associate_service_specification(service_params)
      identification_number = service_specification_params[:service_specification_identification_number]

      return service_params if identification_number.blank?

      service_specification = ServiceSpecification.find_by(identification_number: identification_number)
      service_params.merge(service_specification: service_specification)
    end

    def service_specification_params
      params.require(:service).permit(*PERMITTED_SERVICE_SPECIFICATION_PARAMS)
    end
  end
end
