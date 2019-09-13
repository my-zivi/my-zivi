# frozen_string_literal: true

module V1
  class ServicesController < ApplicationController
    include V1::Concerns::AdminAuthorizable
    include V1::Concerns::ParamsAuthenticatable
    include V1::Concerns::JsonAndPdfRespondable

    PERMITTED_SERVICE_PARAMS = %i[
      user_id beginning ending confirmation_date service_type
      first_swo_service long_service probation_service
      feedback_mail_sent service_specification_id
    ].freeze

    before_action :authenticate_user!, unless: -> { request.format.pdf? }
    before_action :authenticate_from_params!, only: :show, if: -> { request.format.pdf? }
    before_action :set_service, only: %i[show update destroy confirm]
    before_action :protect_foreign_resource!, except: %i[index create], unless: -> { current_user.admin? }
    before_action :authorize_admin!, only: %i[index confirm]
    before_action :protect_confirmed_service!, only: :update, unless: -> { current_user.admin? }

    def index
      year = filter_params[:year]
      @services = year.present? ? Service.at_year(year.to_i).order(:beginning) : Service.all
    end

    def show
      respond_to_json_and_pdf(
        Pdfs::ServiceAgreement::GlueService,
        I18n.t('pdfs.service_agreement.filename', full_name: @service.user.full_name),
        @service
      )
    end

    def create
      @service = Service.new(service_params)

      raise ValidationError, @service.errors unless @service.save

      render :show, status: :created
    end

    def update
      generate_all_sheets = generate_all_sheets?
      generate_missing_sheets = generate_missing_sheets?

      raise ValidationError, @service.errors unless @service.update(service_params)

      ExpenseSheetGenerator.new(@service).create_expense_sheets if generate_all_sheets
      ExpenseSheetGenerator.new(@service).create_missing_expense_sheets if generate_missing_sheets

      render :show
    end

    def destroy
      raise ValidationError, @service.errors unless @service.destroy
    end

    def confirm
      raise ValidationError, @service.errors unless @service.update(confirmation_date: Time.zone.now)

      render :show
    end

    private

    def generate_all_sheets?
      @service.confirmation_date.blank? && service_params[:confirmation_date].present?
    end

    def generate_missing_sheets?
      new_ending = service_params[:ending]
      return false if new_ending.blank?

      @service.confirmation_date.present? && Date.parse(new_ending) > @service.ending_was
    end

    def protect_foreign_resource!
      raise AuthorizationError unless @service.user.id == current_user.id
    end

    def protect_confirmed_service!
      raise AuthorizationError if @service.confirmation_date.present?
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

      permitted_params
    end
  end
end
