# frozen_string_literal: true

module CivilServants
  class ServicesController < BaseController
    include RespondWithPdfConcern

    load_and_authorize_resource
    breadcrumb 'civil_servants.services.index', :civil_servants_services_path
    before_action :show_breadcrumb, only: :show

    def index
      load_filters
      @services = filtered_service.chronologically.includes(:service_specification, :organization)
    end

    def show
      respond_to do |format|
        format.html
        format.pdf { respond_to_pdf }
      end
    end

    private

    def filtered_service
      return @services.definitive if @filters[:show_all]

      @services.definitive.where('ending >= ?', Time.zone.today)
    end

    def load_filters
      @filters = {
        show_all: params.dig(:filters, :show_all) == 'true'
      }
    end

    def respond_to_pdf
      respond_with_pdf(
        render_pdf, I18n.t('pdfs.service_agreement.file_name',
                           name: @service.civil_servant.full_name,
                           beginning: @service.beginning,
                           ending: @service.ending)
      )
    end

    def render_pdf
      Pdfs::ServiceAgreement::FormFiller.render(
        Pdfs::ServiceAgreement::DataProvider.evaluate_data_hash(
          Pdfs::ServiceAgreement::GermanFormFields::SERVICE_AGREEMENT_FIELDS,
          service: @service
        ),
        Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s
      )
    end

    def show_breadcrumb
      title = I18n.t('loaf.breadcrumbs.civil_servants.services.show',
                     beginning: I18n.l(@service.beginning, format: :short),
                     ending: I18n.l(@service.ending, format: :short))

      breadcrumb title, :civil_servants_service_path
    end
  end
end
