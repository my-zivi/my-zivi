# frozen_string_literal: true

module Organizations
  class ServicesController < BaseController
    load_and_authorize_resource :civil_servant
    load_and_authorize_resource :service, through: :civil_servant

    def index
      respond_to do |format|
        format.html
        format.json { render json: ServicesSerializer.call(services) }
      end
    end

    def show; end

    def confirm
      if @service.confirm!
        flash[:success] = I18n.t('organizations.services.confirm.successful_confirm')
        redirect_to organizations_civil_servant_service_path(@civil_servant, @service)
      else
        flash[:error] = I18n.t('organizations.services.confirm.erroneous_confirm')
        redirect_back(fallback_location: organizations_path)
      end
    end

    private

    def services
      @services
        .overlapping_date_range(filter_params[:beginning], filter_params[:ending])
        .joins(:civil_servant)
    end

    def filter_params
      {
        beginning: parse_filter_param(params.dig(:filter, :beginning)) || 1.month.ago.at_beginning_of_month,
        ending: parse_filter_param(params.dig(:filter, :ending)) || 1.month.from_now.at_end_of_month
      }
    end

    # :reek:UtilityFunction
    # :nocov:
    def parse_filter_param(param)
      Date.parse(param) if param
    rescue Date::Error
      nil
    end
    # :nocov:
  end
end
